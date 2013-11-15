#@todo consider removing -doc packages
#apt-get --purge remove tex.\*-doc$

package 'texlive-latex-extra' do #snooooooore
	retries 2
	#todo: increase timeout?
end