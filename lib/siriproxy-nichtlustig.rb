# -*- encoding: utf-8 -*-
require 'cora'
require 'siri_objects'
require 'eat'
require 'nokogiri'
require 'timeout'
require 'httparty'


#######
# 
# This is a simple Plugin which display a cartoon JPG from the german www.nichtlustig.de site 
# sorry for the strange code - im just learning Ruby :-) 
#
#     Remember to add the plugin to the "./siriproxy/config.yml" file
#
######
#
# Das ist ein einfaches plugin, welches eine Cartoonbild von www.nichtlustig.de anzeigt
# 
#      ladet das Plugin in der "./siriproxy/config.yml" datei !
#
########
## ## ##  WIE ES FUNKTIONIERT 
#
## # Syntax
#
# sagt einfach einen Satz mit "Testbild" für das aktuellste nichtlustig Bild
# 
# oder "Zufallsbild" für ein zufälliges Bild (2000-2011)
#
# 
# bei Fragen Twitter: @muhkuh0815
# oder github.com/muhkuh0815/SiriProxy-Nichtlustig
#
#### ToDo
#
# .jpg auf gesamte Breite stretchen - aber k.a. wie :-) 
# andere Kommandos zum abrufen 
#
######


class SiriProxy::Plugin::Nichtlustig < SiriProxy::Plugin
        
    def initialize(config)
        #if you have custom configuration options, process them here!
    end
    def doc
    end
    def docs
    end
    def zuza(zz) # generating filename
    ja = rand(12)
    mo = 1+rand(12)
    ta = 1+rand(31)
    	if ja < 10
    		ja = "0" + ja.to_s
    	end
    	if mo < 10
    		mo = "0" + mo.to_s
    	end
    	if ta < 10
    		ta = "0" + ta.to_s
    	end
    zz = ja.to_s + mo.to_s + ta.to_s
    return zz
    end
    
# Nichtlustig zufälliges Bild - show random image
    
listen_for /(Zufallsbild|zufalls bild|zufallbild|zufall bild|zufallsbedingt)/i do
    zz = zuza(zz)    
    doc = "http://www.nichtlustig.de/comics/full/" + zz + ".jpg"
    begin
    dot = Nokogiri::XML(eat(doc))
    rescue
     	doc = ""
    end
    if doc == NIL or doc == ""
        say "Es gab ein Problem beim Einlesen des Bildes!"
    else
    	dott = dot.xpath('//title')
    	dott = dott.to_s
    	dott = dott.gsub(/<\/?[^>]*>/, "")
    	dott = dott[0,3]
    	z = 0
    	while z == 0 do
  		  	doc = "http://www.nichtlustig.de/comics/full/" + zz + ".jpg"
    			begin
    			dot = Nokogiri::XML(eat(doc))
    			rescue
     			doc = ""
    			end
    		if doc == NIL or doc == ""
    	    	z = 2
    	    else
    			dott = dot.xpath('//title')
    			dott = dott.to_s
    			dott = dott.gsub(/<\/?[^>]*>/, "")
    			dott = dott[0,3]
    			if dott == "404"
    				zz = zuza(zz)
    				z = 0
    			else
    				z = 1
   				end
   			end
    	end
    
    	if z == 1
    		ja = zz[0,2]
    		mo = zz[2,2]
    		ta = zz[4,2]
    		say "hier ist dein NICHTLUSTIG Bild"
    		object = SiriAddViews.new
    		object.make_root(last_ref_id)
    		answer = SiriAnswer.new("www.nichtlustig.de - " + ta + "." + mo + ".20" + ja , [
    	  		SiriAnswerLine.new('logo',doc)
  		 	])
    		object.views << SiriAnswerSnippet.new([answer])
    		send_object object
    	else
    	  	say "Es gab ein Problem beim Einlesen des Bildes!"
    	end
    end
    request_completed
end

# Nichtlustig aktuelles Bild - show latest cartoon
    
listen_for /(Bildtest|Bild Test|Test Bild|testbild)/i do
    begin
    doc = Nokogiri::XML(eat("http://www.nichtlustig.de/rss/nichtrss.rss"))
    rescue
     	doc = ""
    end
    if doc == NIL or doc == ""
        say "Es gab ein Problem beim Einlesen des Bildes!"
    else
    doc.encoding = 'utf-8'
    docs = doc.xpath('//link')
    doc = docs[2]
    doc = doc.to_s
    doc = doc.gsub(/<\/?[^>]*>/, "")
    doc["http://www.nichtlustig.de/toondb/"] = ""
    doc[".html"] = ""
    dos = doc
    doc ="http://www.nichtlustig.de/comics/full/" + doc.to_s + ".jpg"
    ja = dos[0,2]
    mo = dos[2,2]
    ta = dos[4,2]
    say "hier ist dein NICHTLUSTIG Bild"
    object = SiriAddViews.new
    object.make_root(last_ref_id)
    answer = SiriAnswer.new("www.nichtlustig.de - " + ta + "." + mo + ".20" + ja , [
      SiriAnswerLine.new('logo',doc)
    ])
    object.views << SiriAnswerSnippet.new([answer])
    send_object object
    end
    request_completed
end
  
    
end
