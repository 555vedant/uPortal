/**
 * Copyright � 2001 The JA-SIG Collaborative.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. Redistributions of any form whatsoever must retain the following
 *    acknowledgment:
 *    "This product includes software developed by the JA-SIG Collaborative
 *    (http://www.jasig.org/)."
 *
 * THIS SOFTWARE IS PROVIDED BY THE JA-SIG COLLABORATIVE "AS IS" AND ANY
 * EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE JA-SIG COLLABORATIVE OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

package org.jasig.portal.channels;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.jasig.portal.ChannelCacheKey;
import org.jasig.portal.ChannelRuntimeData;
import org.jasig.portal.ChannelStaticData;
import org.jasig.portal.ICacheable;
import org.jasig.portal.IChannel;
import org.jasig.portal.IPrivilegedChannel;
import org.jasig.portal.PortalControlStructures;
import org.jasig.portal.PortalException;
import org.jasig.portal.i18n.LocaleAwareXSLT;
import org.jasig.portal.services.LogService;
import org.jasig.portal.utils.DocumentFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.ContentHandler;

/**
 * CSecureInfo is designed to replace channel instances that are required
 * to be rendered securely, yet the request does not warrant it (i.e. http
 * vs. https).
 *
 * CSecureInfo provides information in place of the actual channel content
 * as it relates to rendering channels that are tagged as secure.
 *
 * The channel is modeled after CError and borrows code from it liberally.
 *
 * @author Keith Stacks, kstacks@sct.com
 * @version $Revision$
 */
public class CSecureInfo extends BaseChannel implements IPrivilegedChannel, ICacheable
{
    protected String str_channelSubscribeId=null;
    protected IChannel the_channel=null;
    
    private static final String ssTitle = "info";
    private static final String sslLocation = "CSecureInfo/CSecureInfo.ssl";
    
    private PortalControlStructures portcs;

    public CSecureInfo() {
    }

    public CSecureInfo(String channelSubscribeId,IChannel channelInstance) {
        this();
        this.str_channelSubscribeId=channelSubscribeId;
        this.the_channel=channelInstance;
    }

    public void setPortalControlStructures(PortalControlStructures pcs) {
        this.portcs=pcs;
    }


    public void renderXML(ContentHandler out) {
        // XML of the following type is generated:
        // <secure>
        //  <channel>
        //   <id>$channelID</id>
        //   <name>$channelName</name>
        //  </channel>
        // </secure>
        //
        Document doc = DocumentFactory.getNewDocument();
        Element secureEl=doc.createElement("secure");
        if(str_channelSubscribeId!=null) {
            Element channelEl=doc.createElement("channel");
            Element idEl=doc.createElement("id");
            idEl.appendChild(doc.createTextNode(str_channelSubscribeId));
            channelEl.appendChild(idEl);

            // determine channel name
            if(portcs!=null) {
                String chName=null;
                try {
                    chName=portcs.getUserPreferencesManager().getUserLayoutManager()
                        .getNode(str_channelSubscribeId).getName();
                } catch (Exception e) {
                    chName="undetermined name";
                }
                if(chName!=null) {
                    Element nameEl=doc.createElement("name");
                    nameEl.appendChild(doc.createTextNode(chName));
                    channelEl.appendChild(nameEl);
                }
                secureEl.appendChild(channelEl);
            }
        }

        doc.appendChild(secureEl);

        // debug block
        try {
            java.io.StringWriter outString = new java.io.StringWriter ();
            org.apache.xml.serialize.OutputFormat format=new org.apache.xml.serialize.OutputFormat();
            format.setOmitXMLDeclaration(true);
            format.setIndenting(true);
            org.apache.xml.serialize.XMLSerializer xsl = new org.apache.xml.serialize.XMLSerializer (outString,format);
            xsl.serialize (doc);
            LogService.log(LogService.DEBUG,outString.toString());
        } catch (Exception e) {
            LogService.log(LogService.DEBUG,e);
        }
        // end of debug block

        try {
            LocaleAwareXSLT xslt = new LocaleAwareXSLT(this, runtimeData.getLocales());
            xslt.setXML(doc);
            xslt.setXSL(sslLocation, ssTitle, runtimeData.getBrowserInfo());
            xslt.setTarget(out);
            xslt.setStylesheetParameter("baseActionURL", runtimeData.getBaseActionURL());
            xslt.transform();
        } catch (Exception e) {
            StringWriter sw=new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            sw.flush();
            LogService.log(LogService.ERROR, "CSecureInfo::renderXML() : Things are bad. Secure info channel threw: " + sw.toString());
        }        
    }


    public ChannelCacheKey generateKey() {
        ChannelCacheKey k=new ChannelCacheKey();
        StringBuffer sbKey = new StringBuffer(1024);

        // assume that security information can be cached system-wide
        k.setKeyScope(ChannelCacheKey.SYSTEM_KEY_SCOPE);
        
        sbKey.append("org.jasig.portal.channels.CSecureInfo: channelID=");
        sbKey.append(str_channelSubscribeId);

        k.setKey(sbKey.toString());
        return k;
    }

    public boolean isCacheValid(Object validity) {
        return true;
    }

    private String toString(boolean b) {
        if(b) return("true"); else return ("false");
    }
}
