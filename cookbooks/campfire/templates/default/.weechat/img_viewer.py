#!/usr/bin/env python

import subprocess
import os
import re
import weechat as w

# TODO
# clear out img_cache every so often.
# settings & filtering
# perform subprocess in bg

SCRIPT_NAME = "img_viewer"
SCRIPT_AUTHOR = "Dan Panzarella"
SCRIPT_VERSION = "0.1"
SCRIPT_DESC = "An Image viewer for pasted URLs to images"

settings = {
    "buffers" : "",
    "ignore_buffers" : "freenode.##news", #comma-separated list of buffers to not listen to
    "url_regex" : "",
    "domain_blacklist" : "",
    "keyword_blacklist" : "",
    "global" : "off",
    "debug": "off" #print debug statements to default buffer
}


octet = r'(?:2(?:[0-4]\d|5[0-5])|1\d\d|\d{1,2})'
ipAddr = r'%s(?:\.%s){3}' % (octet, octet)
# Base domain regex off RFC 1034 and 1738
label = r'[0-9a-z][-0-9a-z]*[0-9a-z]?'
domain = r'%s(?:\.%s)*\.[a-z][-0-9a-z]*[a-z]?' % (label, label)
urlRe = re.compile(r'(\w+://(?:%s|%s)(?::\d+)?(?:/[^\])>\s]*)?)' % (domain, ipAddr), re.I)
imgRe = re.compile(r'.*[\.#](png|jpe?g|gif|tiff|bmp)$',re.I)

def url_recv_cb(data, buffer, time, tags, displayed, highlight, prefix, message):
    if w.config_get_plugin('debug') == 'on':
        w.prnt("","%s: Got url %s" % (SCRIPT_NAME, message))

    #do not trigger on filtered lines and notices
    if displayed == '0' or prefix == w.config_string(w.config_get('weechat.look.prefix_network')):
        #leave alone
        if w.config_get_plugin('debug') == 'on':
            w.prnt("","%s: not displayed, or sent from network. Ignoring" % SCRIPT_NAME)
        return w.WEECHAT_RC_OK

    buf_name = w.buffer_get_string(buffer,"name")
    if w.config_get_plugin('debug') == 'on':
        w.prnt("","%s: from buffer %s" % (SCRIPT_NAME, buf_name))

    #skip ignored buffers
    ignore_buffers = w.config_get_plugin('ignore_buffers').split(',')
    if buf_name in ignore_buffers:
        if w.config_get_plugin('debug') == 'on':
            w.prnt("","%s: %s is on ignore_buffer list" % (SCRIPT_NAME, buf_name))
        return w.WEECHAT_RC_OK

    FNULL=open(os.devnull,'w')

    #can have multiple imgs per msg?
    for url in urlRe.findall(message):
        if w.config_get_plugin('debug') == 'on':
            w.prnt("","%s: testing url %s" % (SCRIPT_NAME,url))
        #is the url for an image?
        if imgRe.match(url):
            if w.config_get_plugin('debug') == 'on':
                w.prnt("","%s: found image!" % SCRIPT_NAME)
            #domain and keyword blacklisting
            #get image
            #subprocess.call(['/usr/bin/wget','-q','--no-use-server-timestamps','-P',"%s/img_cache" % w.info_get("weechat_dir",""), url], stdout=FNULL, stderr=subprocess.STDOUT)
            #fl = subprocess.Popen(['ls','-t','%s/img_cache' % w.info_get("weechat_dir","")],stdout=subprocess.PIPE)
            #fn = subprocess.Popen(['head','-n','1'],stdin=fl.stdout,stdout=subprocess.PIPE)
            #subprocess.call(['sxiv','-q','-'],stdin=fn.stdout,stdout=FNULL,stderr=subprocess.STDOUT,cwd="%s/img_cache" % w.info_get("weechat_dir",""))
            subprocess.call(['%s/get_view_img.sh' % w.info_get("weechat_dir",""),'%s/img_cache' % w.info_get("weechat_dir",""),url],stdout=FNULL,stderr=subprocess.STDOUT)
            
            

    
    return w.WEECHAT_RC_OK 



def config_cb(data, option, value):
    #wat do
    return w.WEECHAT_RC_OK

def img_viewer_close_cb():
    return w.WEECHAT_RC_OK

if __name__ == "__main__":
    if w.register(SCRIPT_NAME,SCRIPT_AUTHOR,SCRIPT_VERSION,"GPL3",SCRIPT_DESC,"img_viewer_close_cb",""):
        for option, default_value in settings.iteritems():
            if not w.config_is_set_plugin(option):
                w.config_set_plugin(option, default_value)
        #w.hook_timer
        w.hook_config("plugins.var.python.%s.*" % SCRIPT_NAME, "config_cb", "")
        w.hook_print("", "", "://", 1, "url_recv_cb", "")
        w.mkdir_home("img_cache",0755)


