<?xml version='1.0' encoding='utf-8' ?>

<!--
Copyright (c) 2001 The JA-SIG Collaborative.  All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.
   
3. Redistributions of any form whatsoever must retain the following
   acknowledgment:
   "This product includes software developed by the JA-SIG Collaborative
   (http://www.jasig.org/)."
   
THIS SOFTWARE IS PROVIDED BY THE JA-SIG COLLABORATIVE "AS IS" AND ANY
EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE JA-SIG COLLABORATIVE OR
ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Justin Tilton, jet@immagic.com
Version $Revision$
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="no"/>

  <!--These variables and parameters are used in all modes-->
  <xsl:param name="baseActionURL" select="'render.userLayoutRootNode.uP'"/>

  <!--modes: view (default), preferences, fragment-->
  <xsl:variable name="mode" select="/layout/@mode"/>
  <xsl:variable name="mediaPath">media/org/jasig/portal/layout/AL_TabColumn/integratedModes</xsl:variable>
  <xsl:param name="skin" select="'immII'"/>
  <xsl:variable name="mediaPathSkin" select="concat($mediaPath,'/',$skin,'/skin')"/>
  <!--<xsl:variable name="mediaPathBorder" select="concat($mediaPath,'/',$skin)"/>-->
  <xsl:variable name="mediaPathHeader" select="concat($mediaPath,'/',$skin,'/institutional')"/>
  <xsl:variable name="mediaPathMainBorder" select="concat($mediaPath,'/',$skin,'/mainBorder')"/>
  <xsl:variable name="mediaPathColumnBorder" select="concat($mediaPath,'/',$skin,'/columnBorder')"/>
  <xsl:variable name="mediaPathIcons" select="concat($mediaPath,'/',$skin,'/icons')"/>
  <xsl:param name="errorMessage" select="'no errorMessage passed'"/>
  <xsl:param name="authenticated" select="'true'"/>
  <xsl:param name="channelManager" select="'true'"/>

  <!--These variables and parameters are used in fragment mode-->
  <xsl:variable name="pushedFragmentFoundation">
    <layout>
      <folder ID="userLayoutRootNode" type="regular" hidden="false" unremovable="false" immutable="false" name="root">
        <folder ID="newFragment" type="regular" hidden="false" unremovable="false" immutable="false" name="Please Name" width="100%"></folder>
      </folder>
    </layout>
  </xsl:variable>

  <!--These variables and parameters are used in preferences mode-->
  <xsl:variable name="selectedID" select="/layout/@selectedID"/>
  <xsl:variable name="focusedTabID" select="/layout/@focusedTabID"/>
  <xsl:variable name="targetRestriction" select="/layout/@targetRestriction"/>
  <xsl:variable name="targetAction" select="/layout/@targetAction"/>
  <xsl:variable name="unauthenticated" select="/layout/@unauthenticated"/>
  <xsl:variable name="userLayoutRoot" select="/layout/@userLayoutRoot"/>


  <!--  Used for detached content  -->
  <xsl:template match="layout_fragment">
    <html>
      <head>
        <title>
          <xsl:value-of select="content/channel/@name"/>
        </title>
        <META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT"></META>
        <META HTTP-EQUIV="pragma" CONTENT="no-cache"></META>
        <link type="text/css" rel="stylesheet" href="{$mediaPath}/{$skin}/skin/{$skin}.css"/>
        <script language="JavaScript">function openBrWindow(theURL,winName,features) {window.open(theURL,winName,features);}</script>
      </head>
      <body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0" class="uportal-background-content">
        <table width="100%" border="0" cellspacing="0" cellpadding="10">
          <tr class="uportal-background-content">
            <td class="uportal-background-content">
              <xsl:for-each select="content//channel">
                <xsl:apply-templates select=".">
                  <xsl:with-param name="detachedContent" select="'true'"/>
                </xsl:apply-templates>
              </xsl:for-each>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>


  <xsl:template match="layout">
    <html>
      <head>
        <title>uPortal 2.1+</title>
        <link type="text/css" rel="stylesheet" href="{$mediaPath}/{$skin}/skin/{$skin}.css"/>
        <xsl:call-template name="scripts"/>
      </head>
      <body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0">
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="scripts">
    <script language="JavaScript"><![CDATA[

     function openBrWindow(theURL,winName,features)
       {window.open(theURL,winName,features);} 

    ]]>
    </script>
  </xsl:template>

  <xsl:template match="header">
    <!-- BEGIN: Masthead and Header Channel -->
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="uportal-background-content">
      <tr>
        <td align="left" valign="top">
          <img src="{$mediaPathHeader}/mainlogo.gif" width="426" height="102"/>
        </td>
        <td width="100%">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>

        <!--BEGIN: Temporary Header Channel: Home,Prefs,Logout -->
        <xsl:if test="not(/layout/login)">
          <td align="right" valign="top">
            <table border="0" cellspacing="10" cellpadding="0">
              <tr>
                <td>
                  <a href="{$baseActionURL}?uP_root=root">
                    <img src="{$mediaPathIcons}/home.gif" width="24" height="24" alt="home" title="home" border="0"/>
                  </a>
                </td>
                <xsl:if test="$userLayoutRoot='root'">

                  <xsl:if test="$channelManager='true'">
                    <td>
                      <a href="{$baseActionURL}?uP_fname=portal/channelmanager/general">
                        <img width="24" height="24" alt="Channel Manager" title="Channel Manager" src="{$mediaPathIcons}/channelmanager.gif" border="0"/>
                      </a>
                    </td>
                  </xsl:if>

                  <xsl:choose>
                    <xsl:when test="$mode='view' and $authenticated='true'">
                      <td>
                        <a href="{$baseActionURL}?uP_sparam=mode&amp;mode=preferences&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}">
                          <img width="24" height="24" alt="Turn on Preferences" title="Turn on Preferences" src="{$mediaPathIcons}/preferences.gif" border="0"/>
                        </a>
                      </td>
                    </xsl:when>

                    <xsl:when test="$mode='preferences'">
                      <td>
                        <a href="{$baseActionURL}?uP_sparam=mode&amp;mode=view&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter&amp;uP_sparam=targetRestriction&amp;targetRestriction=no targetRestriction parameter">
                          <img width="24" height="24" alt="Turn off Preferences" title="Turn off Preferences" src="{$mediaPathIcons}/preferencesoff.gif" border="0"/>
                        </a>
                      </td>
                      <td>
                        <a href="{$baseActionURL}?uP_sparam=uP_save&amp;uP_save=all">
                          <img width="24" height="24" alt="Save Changes" title="Save Changes" src="{$mediaPathIcons}/save.gif" border="0"/>
                        </a>
                      </td>
                    </xsl:when>
                  </xsl:choose>
                </xsl:if>
                <td>
                  <a href="Logout" class="uportal-navigation-category">
                    <img src="{$mediaPathIcons}/logout.gif" width="24" height="24" alt="logout" title="logout" border="0"/>
                  </a>
                </td>
              </tr>
            </table>
          </td>
        </xsl:if>
        <!--END: Temporary Header Channel: Home,Prefs,Logout -->
      </tr>
    </table>
    <!-- END: Masthead and Header Channel -->
  </xsl:template>

  <xsl:template name="actions">
    <!-- BEGIN: upActions Table -->
    <table width="100%" cols="1" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="5" height="5"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td width="100%">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="5" height="5"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/topleftcornerselected.gif" width="20" height="9"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/topborderselected.gif); background-repeat:repeat-x;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/toprightcornerselected.gif" width="19" height="9"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/headerleftborderselected.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="20" height="1"/>
        </td>
        <td nowrap="nowrap" class="uportal-background-selected">
          <span class="uportal-channel-title">User Preferences Actions</span>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/headerrightborderselected.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="19" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/headerbottomleftselected.gif" width="20" height="8"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/headerbottomborderselected.gif); background-repeat:repeat-x;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/headerbottomrightselected.gif" width="19" height="8"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/iconbarlinesleft.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td nowrap="nowrap" class="uportal-background-light">
          <table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td>
                <a href="{$baseActionURL}?uP_sparam=mode&amp;mode=view&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}" class="uportal-label">Turn Preferences off</a>
              </td>
              <td style="background-image: url({$mediaPathMainBorder}/iconbardivider.gif); background-repeat:repeat-y;" valign="bottom">
                <img src="{$mediaPathMainBorder}/iconbardividerbottom.gif" width="12" height="1"/>
              </td>
              <td>
                <a href="{$baseActionURL}?uP_request_add_targets=folder&amp;uP_sparam=mode&amp;mode=preferences&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=targetRestriction&amp;targetRestriction=tab" class="uportal-label">New Tab</a>
              </td>
              <td style="background-image: url({$mediaPathMainBorder}/iconbardivider.gif); background-repeat:repeat-y;" valign="bottom">
                <img src="{$mediaPathMainBorder}/iconbardividerbottom.gif" width="12" height="1"/>
              </td>
              <td>
                <a href="javascript:alert('[Add a column] function is under construction')" class="uportal-label">New Column</a>
              </td>
              <td style="background-image: url({$mediaPathMainBorder}/iconbardivider.gif); background-repeat:repeat-y;" valign="bottom">
                <img src="{$mediaPathMainBorder}/iconbardividerbottom.gif" width="12" height="1"/>
              </td>
              <td>
                <a href="javascript:alert('[Add content] function is under construction')" class="uportal-label">Add Content</a>
              </td>
              <td style="background-image: url({$mediaPathMainBorder}/iconbardivider.gif); background-repeat:repeat-y;" valign="bottom">
                <img src="{$mediaPathMainBorder}/iconbardividerbottom.gif" width="12" height="1"/>
              </td>
              <td>
                <a href="javascript:alert('[Choose a skin] function is under construction')#" class="uportal-label">Skins</a>
              </td>
              <td style="background-image: url({$mediaPathMainBorder}/iconbardivider.gif); background-repeat:repeat-y;" valign="bottom">
                <img src="{$mediaPathMainBorder}/iconbardividerbottom.gif" width="12" height="1"/>
              </td>
              <td>
                <a href="javascript:alert('[Manage Languages] function is under construction')" class="uportal-label">Languages</a>
              </td>
              <td style="background-image: url({$mediaPathMainBorder}/iconbardivider.gif); background-repeat:repeat-y;" valign="bottom">
                <img src="{$mediaPathMainBorder}/iconbardividerbottom.gif" width="12" height="1"/>
              </td>
              <td>
                <a href="javascript:alert('[Manage profiles] function is under construction')" class="uportal-label">Profiles</a>
              </td>
            </tr>
          </table>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/iconbarrightborder.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/iconbarlinesleft.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td nowrap="nowrap" class="uportal-background-light">
          <img src="{$mediaPathSkin}/transparent.gif" width="4" height="4"/>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/iconbarrightborder.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <xsl:if test="not($errorMessage = 'no errorMessage passed')">
        <tr>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td style="background-image: url({$mediaPathMainBorder}/iconbarlinesleft.gif); background-repeat:repeat-y;">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td nowrap="nowrap" class="uportal-background-light">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="3">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3" class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3" class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td>
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
              <tr>
                <td>
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="4">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td>
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="4">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td>
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
              <tr>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="4">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="4">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
              <tr>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2" class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2" class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
              <tr>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2" class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2" class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
              <tr>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2" class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-dark">
                  <span class="uportal-channel-error">
                    <xsl:value-of select="$errorMessage"/>
                  </span>
                </td>
                <td colspan="2" class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
              <tr>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2" class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2" class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
              <tr>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2" class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2" class="uportal-background-dark">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
              <tr>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="4">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="4">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
              <tr>
                <td>
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-content">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="4">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td>
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="4">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td>
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td>
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="2">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
              <tr>
                <td colspan="3">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3" class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3" class="uportal-background-med">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
                <td colspan="3">
                  <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                </td>
              </tr>
            </table>
          </td>
          <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/iconbarrightborder.gif); background-repeat:repeat-y;">
            <img src="{$mediaPathSkin}/transparent.gif" width="11" height="8"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td valign="bottom" style="background-image: url({$mediaPathMainBorder}/iconbarlinesleft.gif); background-repeat:repeat-y;">
          <table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td valign="bottom">
                <img src="{$mediaPathMainBorder}/iconbarlinesbottom.gif" width="20" height="6"/>
              </td>
            </tr>
          </table>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/prefsbottom.gif); background-repeat:repeat-x;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/iconbarrightborder.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathMainBorder}/prefsbottomright.gif" width="19" height="6"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
    </table>
    <!-- End: upActions Table -->
  </xsl:template>


  <xsl:template match="content">
    <xsl:variable name="numCols" select="count(column)"/>
    <table width="100%" border="0" cols="{$numCols}" cellspacing="9" cellpadding="0">
      <tr>
        <xsl:apply-templates>
          <xsl:with-param name="type" select="'column'"/>
        </xsl:apply-templates>
      </tr>
    </table>
  </xsl:template>


  <xsl:template match="channel">
    <!-- Begin Channel Table -->
    <table width="100%" cols="1" border="0" align="center" cellpadding="0" cellspacing="0">
      <xsl:choose>
        <xsl:when test="$selectedID=@ID">
          <tr>
            <td>
              <img src="{$mediaPathMainBorder}/topleftcorner.gif" width="20" height="9"/>
            </td>
            <td width="100%" style="background-image: url({$mediaPathMainBorder}/topborder.gif); background-repeat:repeat-x;">
              <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
            </td>
            <td>
              <img src="{$mediaPathMainBorder}/toprightcorner.gif" width="19" height="9"/>
            </td>
          </tr>
          <tr>
            <td style="background-image: url({$mediaPathMainBorder}/headerleftborderselected.gif); background-repeat:repeat-y;">
              <img src="{$mediaPathSkin}/transparent.gif" width="20" height="1"/>
            </td>
            <td nowrap="nowrap" class="uportal-background-selected">
              <span class="uportal-channel-title">
                <xsl:value-of select="@name"/>
                <xsl:text> </xsl:text>(selected)</span>
            </td>
            <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/headerrightborderselected.gif); background-repeat:repeat-y;">
              <img src="{$mediaPathSkin}/transparent.gif" width="19" height="1"/>
            </td>
          </tr>
          <tr>
            <td>
              <img src="{$mediaPathMainBorder}/headerbottomleft.gif" width="20" height="8"/>
            </td>
            <td style="background-image: url({$mediaPathMainBorder}/headerbottomborder.gif); background-repeat:repeat-x;">
              <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
            </td>
            <td>
              <img src="{$mediaPathMainBorder}/headerbottomright.gif" width="19" height="8"/>
            </td>
          </tr>
        </xsl:when>

        <xsl:otherwise>
          <tr>
            <td>
              <img src="{$mediaPathMainBorder}/topleftcorner.gif" width="20" height="9"/>
            </td>
            <td width="100%" style="background-image: url({$mediaPathMainBorder}/topborder.gif); background-repeat:repeat-x;">
              <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
            </td>
            <td>
              <img src="{$mediaPathMainBorder}/toprightcorner.gif" width="19" height="9"/>
            </td>
          </tr>
          <tr>
            <td style="background-image: url({$mediaPathMainBorder}/headerleftborder.gif); background-repeat:repeat-y;">
              <img src="{$mediaPathSkin}/transparent.gif" width="20" height="1"/>
            </td>
            <td nowrap="nowrap" class="uportal-background-semidark">
              <span class="uportal-channel-title">
                <xsl:value-of select="@name"/>
              </span>
            </td>
            <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/headerrightborder.gif); background-repeat:repeat-y;">
              <img src="{$mediaPathSkin}/transparent.gif" width="19" height="1"/>
            </td>
          </tr>
          <tr>
            <td>
              <img src="{$mediaPathMainBorder}/headerbottomleft.gif" width="20" height="8"/>
            </td>
            <td style="background-image: url({$mediaPathMainBorder}/headerbottomborder.gif); background-repeat:repeat-x;">
              <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
            </td>
            <td>
              <img src="{$mediaPathMainBorder}/headerbottomright.gif" width="19" height="8"/>
            </td>
          </tr>
        </xsl:otherwise>
      </xsl:choose>

      <tr>
        <td style="background-image: url({$mediaPathMainBorder}/iconbarlinesleft.gif); background-repeat:repeat-y;" valign="bottom">
          <img src="{$mediaPathMainBorder}/channellinesbottom.gif" width="20" height="1"/>
        </td>
        <td nowrap="nowrap" class="uportal-background-light">
          <xsl:choose>
            <xsl:when test="$mode='preferences' and $userLayoutRoot='root'">
              <xsl:call-template name="preferencesControls"/>
            </xsl:when>
            <xsl:when test="not($userLayoutRoot='root')">
              <xsl:call-template name="focusedControls"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="controls"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/iconbarrightborder.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="19" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathMainBorder}/channeltopleft.gif" width="20" height="19"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/channeltopborder.gif); background-repeat:repeat-x;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="19"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/channeltopright.gif" width="19" height="19"/>
        </td>
      </tr>
      <tr>
        <td style="background-image: url({$mediaPathMainBorder}/channelleftborder.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="20" height="1"/>
        </td>
        <td class="uportal-background-content">
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td width="100%">
                <xsl:copy-of select="."/>
              </td>
              <td>
                <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
              </td>
            </tr>
          </table>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/channelrightborder.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathMainBorder}/bottomleftcorner.gif" width="20" height="19"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/bottomborder.gif); background-repeat:repeat-x;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/bottomrightcorner.gif" width="19" height="19"/>
        </td>
      </tr>
    </table>
    <!-- End Channel Table -->
    <xsl:variable name="channelID" select="@ID"/>
    <xsl:if test="not($channelID=../channel[last()]/@ID)">
      <!-- Begin Channel Spacer Table -->
      <table width="100%" border="0" cellspacing="0" cellpadding="4">
        <tr>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
      </table>
      <!-- End Channel Spacer Table -->
    </xsl:if>
  </xsl:template>

  <xsl:template match="footer">
  </xsl:template>

  <xsl:template name="preferencesControls">
    <xsl:choose>
      <xsl:when test="$selectedID=@ID and $targetAction='Channel Move'">
        <a href="{$baseActionURL}?uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter&amp;uP_sparam=targetRestriction&amp;targetRestriction=no targetRestriction parameter">
          <img src="{$mediaPathIcons}/contentcancelmove.gif" width="26" height="23" alt="Cancel Channel Move" title="Cancel Channel Move" border="0"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$baseActionURL}?uP_request_move_targets={@ID}&amp;uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=selectedID&amp;selectedID={@ID}&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=targetRestriction&amp;targetRestriction=channel&amp;uP_sparam=targetAction&amp;targetAction=Channel Move">
          <img src="{$mediaPathIcons}/contentmove.gif" width="26" height="23" alt="move this channel" title="move this channel" border="0"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
    <a href="#">
      <img src="{$mediaPathIcons}/contentlanguages.gif" width="26" height="23" alt="change language for this channel" title="change language for this channel" border="0"/>
    </a>
    <a href="{$baseActionURL}?uP_remove_target={@ID}&amp;uP_sparam=mode&amp;mode={$mode} onClick="return confirm('Are you sure you want to delete this channel?')">
      <img src="{$mediaPathIcons}/contentcan.gif" width="26" height="23" alt="delete this channel" title="delete this channel" border="0"/>
    </a>
  </xsl:template>

  <xsl:template name="focusedControls">
    <a href="{$baseActionURL}?uP_root=root">
      <img alt="return" title="return" src="{$mediaPathIcons}/return.gif" width="26" height="23" border="0"/>
    </a>
    <xsl:if test="not(@hasHelp='false')">
      <a href="{$baseActionURL}?uP_help_target={@ID}">
        <img alt="help" title="help" src="{$mediaPathIcons}/contenthelp.gif" width="26" height="23" border="0"/>
      </a>
    </xsl:if>
    <xsl:if test="not(@hasAbout='false')">
      <a href="{$baseActionURL}?uP_about_target={@ID}">
        <img alt="about" title="about" src="{$mediaPathIcons}/contentabout.gif" width="26" height="23" border="0"/>
      </a>
    </xsl:if>
    <xsl:if test="not(@editable='false')">
      <a href="{$baseActionURL}?uP_edit_target={@ID}">
        <img alt="edit" title="edit" src="{$mediaPathIcons}/contentedit.gif" width="26" height="23" border="0"/>
      </a>
    </xsl:if>
    <xsl:if test="@printable='true'">
      <a href="{$baseActionURL}?uP_print_target={@ID}">
        <img alt="print" title="print" src="{$mediaPathIcons}/contentprint.gif" width="26" height="23" border="0"/>
      </a>
    </xsl:if>
  </xsl:template>

  <xsl:template name="controls">
    <xsl:if test="not(@hasHelp='false')">
      <a href="{$baseActionURL}?uP_help_target={@ID}">
        <img alt="help" title="help" src="{$mediaPathIcons}/contenthelp.gif" width="26" height="23" border="0"/>
      </a>
    </xsl:if>
    <xsl:if test="not(@hasAbout='false')">
      <a href="{$baseActionURL}?uP_about_target={@ID}">
        <img alt="about" title="about" src="{$mediaPathIcons}/contentabout.gif" width="26" height="23" border="0"/>
      </a>
    </xsl:if>
    <xsl:if test="not(@editable='false')">
      <a href="{$baseActionURL}?uP_edit_target={@ID}">
        <img alt="edit" title="edit" src="{$mediaPathIcons}/contentedit.gif" width="26" height="23" border="0"/>
      </a>
    </xsl:if>
    <xsl:if test="@printable='true'">
      <a href="{$baseActionURL}?uP_print_target={@ID}">
        <img alt="print" title="print" src="{$mediaPathIcons}/contentprint.gif" width="26" height="23" border="0"/>
      </a>
    </xsl:if>
    <a href="{$baseActionURL}?uP_root={@ID}">
      <img alt="focus" title="focus" src="{$mediaPathIcons}/contentfocus.gif" width="26" height="23" border="0"/>
    </a>
    <xsl:choose>
      <xsl:when test="@minimized='true'">
        <a href="{$baseActionURL}?uP_tcattr=minimized&amp;minimized_channelId={@ID}&amp;minimized_{@ID}_value=false">
          <img alt="maximize" title="maximize" src="{$mediaPathIcons}/contentmaximize.gif" width="26" height="23" border="0"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$baseActionURL}?uP_tcattr=minimized&amp;minimized_channelId={@ID}&amp;minimized_{@ID}_value=true">
          <img alt="minimize" title="minimize" src="{$mediaPathIcons}/contentminimize.gif" width="26" height="23" border="0"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>

    <a href="#" onClick="openBrWindow('{$baseActionURL}?uP_detach_target={@ID}','detachedChannel','toolbar=yes,location=yes,status=yes,menubar=yes,scrollbars=yes,resizable=yes,width=640,height=480')">
      <img alt="detach" title="detach" src="{$mediaPathIcons}/contentdetach.gif" width="26" height="23" border="0"/>
    </a>
    <xsl:if test="not(@unremovable='true')">
      <a href="{$baseActionURL}?uP_remove_target={@ID}" onClick="return confirm('Are you sure you want to delete this channel?')">
        <img alt="delete this channel" title="delete this channel" src="{$mediaPathIcons}/contentcan.gif" width="26" height="23" border="0"/>
      </a>
    </xsl:if>
  </xsl:template>

  <xsl:template name="detachedChannelControls">
    <xsl:if test="not(@hasHelp='false')">
      <a href="{$baseActionURL}?uP_help_target={@ID}">
        <img alt="help" title="help" src="{$mediaPath}/{$skin}/controls/help.gif" width="16" height="16" border="0"/>
      </a>
    </xsl:if>
    <xsl:if test="not(@hasAbout='false')">
      <a href="{$baseActionURL}?uP_about_target={@ID}">
        <img alt="about" title="about" src="{$mediaPath}/{$skin}/controls/about.gif" width="16" height="16" border="0"/>
      </a>
    </xsl:if>
    <xsl:if test="not(@editable='false')">
      <a href="{$baseActionURL}?uP_edit_target={@ID}">
        <img alt="edit" title="edit" src="{$mediaPath}/{$skin}/controls/edit.gif" width="16" height="16" border="0"/>
      </a>
    </xsl:if>
    <xsl:if test="@printable='true'">
      <a href="{$baseActionURL}?uP_print_target={@ID}">
        <img alt="print" title="print" src="{$mediaPath}/{$skin}/controls/print.gif" width="16" height="16" border="0"/>
      </a>
    </xsl:if>
  </xsl:template>

  <xsl:template match="focusedContent">
    <table width="100%" cols="2" border="0" cellspacing="9" cellpadding="0">
      <tr>
        <td valign="top" width="100%" class="uportal-background-dark">
          <xsl:apply-templates select="*"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="navigation">
    <!-- Begin Tab Block -->
    <table width="100%" cols="1" border="0" cellspacing="0" cellpadding="0" class="uportal-background-content">
      <!--Determined that Form is unneccessary-->
      <!--			<form name="formRename" method="post" action="{$baseActionURL}">-->
      <tr>
        <xsl:apply-templates>
          <xsl:with-param name="type" select="'tab'"/>
        </xsl:apply-templates>
        <td width="100%" valign="bottom" class="uportal-background-content">
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td>
                <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
              </td>
            </tr>
            <tr class="uportal-background-shadow">
              <td>
                <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <!--			</form>-->
    </table>
    <!-- End Tab Block -->
  </xsl:template>


  <xsl:template match="inactiveTab">
    <td valign="bottom">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td colspan="5" class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
          </td>
          <td class="uportal-background-content" colspan="5">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr>
          <td colspan="4" class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content" colspan="4">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-light">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content" colspan="3">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td nowrap="nowrap" class="uportal-background-med">
						<table border="0" cellspacing="0" cellpadding="4">
							<tr>
								<td nowrap="nowrap">
									<xsl:choose>
										<xsl:when test="$targetAction='Tab Move' or $targetAction='Channel Move' or $targetAction='Column Move'">
											<a class="uportal-navigation-category" href="{$baseActionURL}?uP_request_move_targets={$selectedID}&amp;uP_sparam=focusedTabID&amp;focusedTabID={@ID}&amp;uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=selectedID&amp;selectedID={$selectedID}&amp;uP_sparam=targetRestriction&amp;targetRestriction={$targetRestriction}">
												<xsl:value-of select="@name"/>
											</a>
										</xsl:when>
										<xsl:when test="$targetAction='New Tab' or $targetAction='New Channel' or $targetAction='New Column'">
											<a class="uportal-navigation-category" href="{$baseActionURL}?uP_request_add_targets={$selectedID}&amp;uP_sparam=focusedTabID&amp;focusedTabID={@ID}&amp;uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=selectedID&amp;selectedID={$selectedID}&amp;uP_sparam=targetRestriction&amp;targetRestriction={$targetRestriction}">
												<xsl:value-of select="@name"/>
											</a>
										</xsl:when>
										<xsl:otherwise>
											<a class="uportal-navigation-category" href="{$baseActionURL}?uP_sparam=focusedTabID&amp;focusedTabID={@ID}&amp;uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter">
												<xsl:value-of select="@name"/>
											</a>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</table>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-light">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-light">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr class="uportal-background-shadow">
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="2" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="2" height="1"/>
          </td>
        </tr>
      </table>
    </td>
  </xsl:template>

  <xsl:template match="focusedTab">
    <td valign="bottom">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td colspan="5" class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
          </td>
          <td class="uportal-background-content" colspan="5">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr>
          <td colspan="4" class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content" colspan="4">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-light">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content" colspan="3">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td nowrap="nowrap" class="uportal-background-dark">
            <!--Tab name block-->
            <table border="0" cellspacing="0" cellpadding="4">
              <tr>
                <form name="formRename" method="post" action="{$baseActionURL}">
                  <xsl:choose>
                    <xsl:when test="$mode='view'">
                      <td nowrap="nowrap" class="navigation-selected">
                        <xsl:value-of select="@name"/>
                      </td>
                    </xsl:when>
                    <xsl:when test="$mode='preferences'">
                      <td nowrap="nowrap">
                        <xsl:choose>
                          <xsl:when test="@immutable='false'">
                            <input name="uP_target_name" type="text" class="uportal-input-text" value="{@name}">
                              <xsl:attribute name="size">
                                <xsl:value-of select="string-length(@name)"/>
                              </xsl:attribute>
                            </input>
                            <input type="hidden" name="uP_rename_target" value="{@ID}"/>
                            <input type="hidden" name="uP_sparam" value="mode"/>
                            <input type="hidden" name="mode" value="{$mode}"/>
                            <input type="hidden" name="uP_sparam" value="focusedTabID"/>
                            <input type="hidden" name="focusedTabID" value="{$focusedTabID}"/>
                            <input name="renameTab" type="image" src="{$mediaPathIcons}/submit.gif" width="22" height="18" border="0" alt="Submit new tab name" title="Submit new tab name"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <span class="uportal-navigation-category-selected">
                              <xsl:value-of select="@name"/>
                            </span>
                          </xsl:otherwise>
                        </xsl:choose>
                        <img src="{$mediaPathSkin}/transparent.gif" width="8" height="8"/>
                        <a href="{$baseActionURL}?uP_request_move_targets={@ID}&amp;uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=selectedID&amp;selectedID={@ID}&amp;uP_sparam=focusedTabID&amp;focusedTabID={@ID}&amp;uP_sparam=targetRestriction&amp;targetRestriction=tab&amp;uP_sparam=targetAction&amp;targetAction=Tab Move">
                          <img alt="Move this tab" title="Move this tab" src="{$mediaPathIcons}/moveicon.gif" width="22" height="18" border="0"/>
                        </a>
                        <a href="#">
                          <img alt="Change language for this tab" title="Change language for this tab" src="{$mediaPathIcons}/languagesG.gif" width="22" height="18" border="0"/>
                        </a>
                        <xsl:if test="@unremovable='false'">
                          <a href="{$baseActionURL}?uP_remove_target={@ID}&amp;uP_sparam=mode&amp;mode={$mode} onClick="return confirm('Are you sure you want to delete this tab?')">
                            <img alt="delete this tab" title="delete this tab" src="{$mediaPathIcons}/canicon.gif" width="22" height="18" border="0"/>
                          </a>
                        </xsl:if>
                      </td>
                    </xsl:when>
                  </xsl:choose>
                </form>
              </tr>
            </table>
            <!--End Tab name block-->
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-light">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-dark">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-light">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr class="uportal-background-dark">
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="2" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="2" height="1"/>
          </td>
        </tr>
      </table>
    </td>
  </xsl:template>

  <xsl:template match="selectedTab">
    <td valign="bottom">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td colspan="5" class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
          </td>
          <td class="uportal-background-content" colspan="5">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr>
          <td colspan="4" class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="4" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content" colspan="4">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr>
          <td colspan="3" class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-light">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content" colspan="3">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr>
          <td width="2" class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td nowrap="nowrap" class="uportal-background-selected">
            <!-- Begin Selected Tab Content Table -->
            <table border="0" cellspacing="0" cellpadding="4">
              <tr>
                <td class="uportal-background-selected" nowrap="nowrap">
                  <span class="uportal-navigation-category-selected">
                    <xsl:value-of select="@name"/>
                  </span>
                  <img src="{$mediaPathSkin}/transparent.gif" width="8" height="8"/>
                  <a href="{$baseActionURL}?uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter&amp;uP_sparam=targetRestriction&amp;targetRestriction=no targetRestriction parameter">
                    <img src="{$mediaPathIcons}/cancelmoveicon.gif" width="20" height="17" alt="Cancel Tab Move" title="Cancel Tab Move" border="0"/>
                  </a>
                </td>
              </tr>
            </table>
            <!-- End Selected Tab Content Table -->
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-light">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-med">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-selected">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-light">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-content">
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
        </tr>
        <tr class="uportal-background-dark">
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="2" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td>
            <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
          </td>
          <td class="uportal-background-shadow">
            <img src="{$mediaPathSkin}/transparent.gif" width="2" height="1"/>
          </td>
        </tr>
      </table>
    </td>
  </xsl:template>

  <xsl:template match="move_target">
    <xsl:param name="type"/>
    <xsl:choose>
      <xsl:when test="$type='tab'">
        <!-- Move target Icon for Tabs -->
        <td align="center" valign="bottom" class="uportal-background-content">
          <table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td>
                <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
              </td>
              <td valign="middle" width="100%">
                <a href="{$baseActionURL}?uP_move_target={$selectedID}&amp;targetNextID={@nextID}&amp;targetParentID={@parentID}&amp;uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter&amp;uP_sparam=targetRestriction&amp;targetRestriction=no targetRestriction parameter">
                  <img alt="Click to select target location" title="Click to select target location" src="{$mediaPathIcons}/airplanetarget.gif" width="16" height="16" border="0"/>
                </a>
              </td>
              <td>
                <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
              </td>
            </tr>
            <tr>
              <td>
                <img src="{$mediaPathSkin}/transparent.gif" width="1" height="5"/>
              </td>
              <td>
                <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
              </td>
              <td>
                <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
              </td>
            </tr>
            <tr class="uportal-background-shadow">
              <td>
                <img src="{$mediaPathSkin}/transparent.gif" width="5" height="1"/>
              </td>
              <td>
                <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
              </td>
              <td>
                <img src="{$mediaPathSkin}/transparent.gif" width="5" height="1"/>
              </td>
            </tr>
          </table>
        </td>
        <!-- End Move Target Icon -->
      </xsl:when>
      <xsl:when test="$type='column'">
        <td valign="top">
          <a href="{$baseActionURL}?uP_move_target={$selectedID}&amp;targetNextID={@nextID}&amp;targetParentID={@parentID}&amp;uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter&amp;uP_sparam=targetRestriction&amp;targetRestriction=no targetRestriction parameter">
            <img alt="Click to move column here" title="Click to move column here" src="{$mediaPathIcons}/add_column_ani.gif" width="22" height="18" border="0"/>
          </a>
        </td>
      </xsl:when>
      <xsl:when test="$type='channel'">
        <table width="100%" border="0" cellspacing="0" cellpadding="4">
          <tr>
            <td align="center">
              <a href="{$baseActionURL}?uP_move_target={$selectedID}&amp;targetNextID={@nextID}&amp;targetParentID={@parentID}&amp;uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter&amp;uP_sparam=targetRestriction&amp;targetRestriction=no targetRestriction parameter">
                <img alt="Click to move channel here" title="Click to move channel here" src="{$mediaPathIcons}/add_channel_ani.gif" width="22" height="18" border="0"/>
              </a>
            </td>
          </tr>
        </table>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="add_target">

    <!-- Add target Icon in the Tabline -->
    <xsl:if test="$targetRestriction='tab'">
      <td align="center" valign="bottom" class="uportal-background-content">
        <table border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>
              <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
            </td>
            <td valign="middle">
              <a href="{$baseActionURL}?uP_add_target=folder&amp;targetNextID={@nextID}&amp;targetParentID={@parentID}&amp;uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter">
                <img alt="Click to add new tab here" title="Click to add new tab here" src="{$mediaPathIcons}/airplanetarget.gif" width="16" height="16" border="0"/>
              </a>
            </td>
            <td>
              <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
            </td>
          </tr>
          <tr>
            <td>
              <img src="{$mediaPathSkin}/transparent.gif" width="1" height="5"/>
            </td>
            <td>
              <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
            </td>
            <td>
              <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
            </td>
          </tr>
          <tr class="uportal-background-shadow">
            <td>
              <img src="{$mediaPathSkin}/transparent.gif" width="5" height="1"/>
            </td>
            <td>
              <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
            </td>
            <td>
              <img src="{$mediaPathSkin}/transparent.gif" width="5" height="1"/>
            </td>
          </tr>
        </table>
      </td>
    </xsl:if>
    <!-- End Add Target Icon in the Tabline -->

    <!-- Add target Icon in the Columns -->
    <xsl:if test="$targetRestriction='column'">
      <td align="center" valign="top">
        <table border="0" cellspacing="0" cellpadding="5" class="uportal-background-neutral-light">
          <tr>
            <td valign="top">
              <a href="{$baseActionURL}?uP_add_target=folder&amp;targetNextID={@nextID}&amp;targetParentID={@parentID}&amp;uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter">
                <img alt="Click to add new column here" title="Click to add new column here" src="{$mediaPathIcons}/add_column_ani.gif" width="22" height="18" border="0"/>
              </a>
            </td>
          </tr>
        </table>
      </td>
    </xsl:if>
    <!-- End Add Target Icon in the Columns -->

    <!-- Add target Icon in the Channels -->
    <xsl:if test="$targetRestriction='channel'">
      <table width="100%" border="0" cellspacing="0" cellpadding="4">
        <tr>
          <td align="center">
            <a href="{$baseActionURL}?uP_add_target=channel&amp;targetNextID={@nextID}&amp;targetParentID={@parentID}&amp;uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter">
              <img alt="Click to add new channel here" title="Click to add new channel here" src="{$mediaPathIcons}/add_channel_ani.gif" width="22" height="18" border="0"/>
            </a>
          </td>
        </tr>
      </table>
    </xsl:if>
    <!-- End Add Target Icon in the Channels -->
  </xsl:template>




  <xsl:template match="@name" mode="view">
    <td nowrap="nowrap" class="uportal-navigation-category-selected">
      <xsl:value-of select="."/>
    </td>
  </xsl:template>

  <xsl:template match="@name" mode="preferences">
    <td nowrap="nowrap">
      <a class="uportal-navigation-category" href="#">
        <xsl:value-of select="."/>
      </a>
    </td>
  </xsl:template>

  <xsl:template match="login">
    <table width="100%" cols="1" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="5" height="5"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td width="100%">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="5" height="5"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/topleftcornerselected.gif" width="20" height="9"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/topborderselected.gif); background-repeat:repeat-x;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/toprightcornerselected.gif" width="19" height="9"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/headerleftborderselected.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="20" height="1"/>
        </td>
        <td nowrap="nowrap" class="uportal-background-selected">
          <span class="uportal-channel-title">User Login</span>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/headerrightborderselected.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="19" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/headerbottomleftselected.gif" width="20" height="8"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/headerbottomborderselected.gif); background-repeat:repeat-x;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/headerbottomrightselected.gif" width="19" height="8"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/iconbarlinesleft.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td nowrap="nowrap" class="uportal-background-light">
          <xsl:copy-of select="channel"/>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/iconbarrightborder.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="19" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td valign="bottom" style="background-image: url({$mediaPathMainBorder}/iconbarlinesleft.gif); background-repeat:repeat-y;">
          <table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td valign="bottom">
                <img src="{$mediaPathMainBorder}/iconbarlinesbottom.gif" width="20" height="6"/>
              </td>
            </tr>
          </table>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/prefsbottom.gif); background-repeat:repeat-x;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/iconbarrightborder.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathMainBorder}/prefsbottomright.gif" width="19" height="6"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template match="actions">
    <table width="100%" cols="1" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="9" height="9"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td width="100%">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="9" height="9"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/topleftcornerselected.gif" width="20" height="9"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/topborderselected.gif); background-repeat:repeat-x;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/toprightcornerselected.gif" width="19" height="9"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/headerleftborderselected.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="20" height="1"/>
        </td>
        <td nowrap="nowrap" class="uportal-background-selected">
          <span class="uportal-channel-title">User Preferences Actions</span>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/headerrightborderselected.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="19" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/headerbottomleftselected.gif" width="20" height="8"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/headerbottomborderselected.gif); background-repeat:repeat-x;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathMainBorder}/headerbottomrightselected.gif" width="19" height="8"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/iconbarlinesleft.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td align="left" class="uportal-background-light">
          <span class="uportal-label">
            <xsl:if test="not($targetRestriction='no targetRestriction parameter')">
              <a href="{$baseActionURL}?uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter&amp;uP_sparam=targetRestriction&amp;targetRestriction=no targetRestriction parameter">Cancel&#160;<xsl:value-of select="$targetAction"/></a>
              <span>&#160;|<xsl:text> </xsl:text></span>
            </xsl:if>
            <a href="{$baseActionURL}?uP_sparam=mode&amp;mode=view&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter&amp;uP_sparam=targetRestriction&amp;targetRestriction=no targetRestriction parameter">Turn&#160;Preferneces&#160;Off</a>
            <span>&#160;|<xsl:text> </xsl:text></span>
            <a href="{$baseActionURL}?uP_request_add_targets=folder&amp;uP_sparam=mode&amp;mode=preferences&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=targetRestriction&amp;targetRestriction=tab&amp;uP_sparam=targetAction&amp;targetAction=New Tab">New&#160;Tab</a>
            <span>&#160;|<xsl:text> </xsl:text></span>
            <a href="{$baseActionURL}?uP_request_add_targets=folder&amp;uP_sparam=mode&amp;mode=preferences&amp;uP_sparam=targetRestriction&amp;targetRestriction=column&amp;uP_sparam=targetAction&amp;targetAction=New Column">New&#160;Column</a>
            <span>&#160;|<xsl:text> </xsl:text></span>
            <a href="{$baseActionURL}?uP_fname=contentsubscriber">Add&#160;Content</a>
            <span>&#160;|<xsl:text> </xsl:text></span>
            <a href="{$baseActionURL}?uP_fname=skinselector">Skins</a>
            <span>&#160;|<xsl:text> </xsl:text></span>
            <a href="javascript:alert('[Languages] function is under construction')">Layout Languages</a>
            <span>&#160;|<xsl:text> </xsl:text></span>
            <a href="javascript:alert('[Profiles] function is under construction')">Profiles</a>
            <xsl:if test="alternateLayouts">
              <span>&#160;|<xsl:text> </xsl:text></span>Manage:&#160;<select name="select" class="uportal-input-text uportal-background-content"><option selected="selected">My layout</option><xsl:for-each select="alternateLayouts/alternate"><option><xsl:value-of select="@name"/></option></xsl:for-each></select>
              <!--<option><xsl:value-of select="New fragment"/></option>--><input name="manageLayout" type="image" src="{$mediaPathIcons}/submit.gif" width="22" height="18" border="0" alt="Modify this layout" title="Modify this layout"/>
              <!-- <span>&#160;|<xsl:text> </xsl:text></span><a href="javascript:alert('[Layout Publish] function is under construction')">Copy Tab to Fragment</a> --><span>&#160;|<xsl:text> </xsl:text></span><a href="javascript:alert('[New fragment] function is under construction')">New fragment</a></xsl:if>
          </span>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/iconbarrightborder.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/iconbarlinesleft.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td nowrap="nowrap" class="uportal-background-light">
          <img src="{$mediaPathSkin}/transparent.gif" width="4" height="4"/>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/iconbarrightborder.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <xsl:choose>
        <xsl:when test="not($errorMessage='no errorMessage passed')">
          <xsl:call-template name="messageRow"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="statusCheck"/>
        </xsl:otherwise>
      </xsl:choose>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td valign="bottom" style="background-image: url({$mediaPathMainBorder}/iconbarlinesleft.gif); background-repeat:repeat-y;">
          <table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td valign="bottom">
                <img src="{$mediaPathMainBorder}/iconbarlinesbottom.gif" width="20" height="6"/>
              </td>
            </tr>
          </table>
        </td>
        <td style="background-image: url({$mediaPathMainBorder}/prefsbottom.gif); background-repeat:repeat-x;">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/iconbarrightborder.gif); background-repeat:repeat-y;">
          <img src="{$mediaPathMainBorder}/prefsbottomright.gif" width="19" height="6"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
    </table>
  </xsl:template>

  <xsl:template name="statusCheck">
  </xsl:template>

  <xsl:template name="messageRow">
    <!-- Message Row -->
    <tr>
      <td>
        <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
      </td>
      <td style="background-image: url({$mediaPathMainBorder}/iconbarlinesleft.gif); background-repeat:repeat-y;">
        <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
      </td>
      <td nowrap="nowrap" class="uportal-background-light">
        <xsl:call-template name="message"/>
      </td>
      <td class="uportal-background-dark" style="background-image: url({$mediaPathMainBorder}/iconbarrightborder.gif); background-repeat:repeat-y;">
        <img src="{$mediaPathSkin}/transparent.gif" width="11" height="8"/>
      </td>
      <td>
        <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
      </td>
    </tr>
    <!-- End Message Row -->
  </xsl:template>

  <xsl:template name="message">
    <xsl:param name="messageString" select="$errorMessage"/>
    <!-- Message Table -->
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td colspan="3">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3" class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3" class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="4">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="4">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="4">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="4">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2" class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2" class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2" class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2" class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2" class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-dark">
          <span class="uportal-channel-title">
            <xsl:value-of select="$messageString"/>
          </span>
        </td>
        <td colspan="2" class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2" class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2" class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2" class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2" class="uportal-background-dark">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="4">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="4">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-content">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="4">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="4">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td>
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="2">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
      <tr>
        <td colspan="3">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3" class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3" class="uportal-background-med">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
        <td colspan="3">
          <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
        </td>
      </tr>
    </table>
    <!-- End Message Table -->
  </xsl:template>

  <xsl:template match="column">
    <xsl:choose>
      <xsl:when test="$mode='preferences'">

        <td valign="top" width="{@width}">
          <!-- Begin Column Table -->
          <table width="100%" cols="1" border="0" align="center" cellpadding="0" cellspacing="0">
            <xsl:choose>
              <xsl:when test="@ID=$selectedID">
                <tr>
                  <td>
                    <img src="{$mediaPathColumnBorder}/topleftcornerGselected.gif" width="20" height="9"/>
                  </td>
                  <td width="100%" style="background-image: url({$mediaPathColumnBorder}/topborderGselected.gif); background-repeat:repeat-x;">
                    <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                  </td>
                  <td>
                    <img src="{$mediaPathColumnBorder}/toprightcornerGselected.gif" width="20" height="9"/>
                  </td>
                </tr>
                <tr>
                  <td style="background-image: url({$mediaPathColumnBorder}/headerleftborderselectedG.gif); background-repeat:repeat-y;">
                    <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                  </td>

                  <td nowrap="nowrap" class="uportal-background-selected">
                    <span class="uportal-channel-title">Selected Column</span>
                  </td>
                  <td style="background-image: url({$mediaPathColumnBorder}/headerrightborderselectedG.gif); background-repeat:repeat-y;">
                    <img src="{$mediaPathSkin}/transparent.gif" width="20" height="1"/>
                  </td>
                </tr>
                <tr>
                  <td>
                    <img src="{$mediaPathColumnBorder}/headerbottomleftGselected.gif" width="20" height="2"/>
                  </td>
                  <td style="background-image: url({$mediaPathColumnBorder}/headerbottomborderGselected.gif); background-repeat:repeat-x;">
                    <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                  </td>
                  <td>
                    <img src="{$mediaPathColumnBorder}/headerbottomrightGselected.gif" width="20" height="2"/>
                  </td>
                </tr>
              </xsl:when>
              <xsl:otherwise>
                <tr>
                  <td>
                    <img src="{$mediaPathColumnBorder}/topleftcornerG.gif" width="20" height="8"/>
                  </td>
                  <td width="100%" style="background-image: url({$mediaPathColumnBorder}/topborderG.gif); background-repeat:repeat-x;">
                    <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                  </td>
                  <td>
                    <img src="{$mediaPathColumnBorder}/toprightcornerG.gif" width="20" height="8"/>
                  </td>
                </tr>
                <tr>
                  <td style="background-image: url({$mediaPathColumnBorder}/headerleftborderG.gif); background-repeat:repeat-y;">
                    <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                  </td>
                  <td nowrap="nowrap" class="uportal-background-neutral-dark">
                    <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                  </td>
                  <td class="uportal-background-dark" style="background-image: url({$mediaPathColumnBorder}/headerrightborderG.gif); background-repeat:repeat-y;">
                    <img src="{$mediaPathSkin}/transparent.gif" width="20" height="1"/>
                  </td>
                </tr>
                <tr>
                  <td>
                    <img src="{$mediaPathColumnBorder}/headerbottomleftG.gif" width="20" height="1"/>
                  </td>
                  <td style="background-image: url({$mediaPathColumnBorder}/headerbottomborderG.gif); background-repeat:repeat-x;">
                    <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
                  </td>
                  <td>
                    <img src="{$mediaPathColumnBorder}/headerbottomrightG.gif" width="20" height="1"/>
                  </td>
                </tr>
              </xsl:otherwise>
            </xsl:choose>
            <tr>
              <td class="uportal-background-neutral-light">
                <img src="{$mediaPathColumnBorder}/iconbarlinesleftG.gif" width="20" height="38"/>
              </td>
              <td nowrap="nowrap" class="uportal-background-neutral-light">
                <table border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <xsl:choose>
                        <xsl:when test="$selectedID=@ID and $targetAction='Column Move'">
                          <a href="{$baseActionURL}?uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=selectedID&amp;selectedID=no selectedID parameter&amp;uP_sparam=targetRestriction&amp;targetRestriction=no targetRestriction parameter">
                            <img src="{$mediaPathIcons}/columncancelmove.gif" width="28" height="25" alt="cancel move action" title="cancel move action" border="0"/>
                          </a>
                        </xsl:when>
                        <xsl:otherwise>
                          <a href="{$baseActionURL}?uP_request_move_targets={@ID}&amp;uP_sparam=mode&amp;mode={$mode}&amp;uP_sparam=selectedID&amp;selectedID={@ID}&amp;uP_sparam=focusedTabID&amp;focusedTabID={$focusedTabID}&amp;uP_sparam=targetRestriction&amp;targetRestriction=column&amp;uP_sparam=targetAction&amp;targetAction=Column Move">
                            <img src="{$mediaPathIcons}/columnmove.gif" width="28" height="25" alt="move this column" title="move this column" border="0"/>
                          </a>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>

                    <td>
                      <a href="#">
                        <img src="{$mediaPathIcons}/columnlanguages.gif" width="28" height="25" alt="change language for this column" title="change language for this column" border="0"/>
                      </a>
                    </td>

                    <td>
                      <a href="{$baseActionURL}?uP_remove_target={@ID}&amp;uP_sparam=mode&amp;mode={$mode} onClick="return confirm('Are you sure you want to delete this column?')">
                        <img src="{$mediaPathIcons}/columncan.gif" width="28" height="25" alt="delete this column" title="delete this column" border="0"/>
                      </a>
                    </td>

                    <xsl:if test="count(../column)&gt;1">
                      <xsl:if test="number(substring-before(@width,'%'))&gt;4">
                        <form name="formResizeColumn" method="post" action="{$baseActionURL}">
                          <td>
                            <xsl:call-template name="calculateShrinkColumn"/>
                          </td>
                        </form>
                      </xsl:if>

                      <xsl:if test="number(substring-before(@width,'%'))&lt;96">
                        <form name="formResizeColumn" method="post" action="{$baseActionURL}">
                          <td>
                            <xsl:call-template name="calculateExpandColumn"/>
                          </td>
                        </form>
                      </xsl:if>
                    </xsl:if>
                    <xsl:call-template name="normalizeColumnWidths"/>


                    <td valign="middle" nowrap="nowrap">
                      <img src="{$mediaPathSkin}/transparent.gif" width="5" height="1"/>
                      <span class="uportal-channel-strong">
                        <xsl:value-of select="@width"/>
                      </span>
                    </td>
                  </tr>
                </table>
              </td>
              <td class="uportal-background-dark" style="background-image: url({$mediaPathColumnBorder}/iconbarrightborderG.gif); background-repeat:repeat-y;">
                <img src="{$mediaPathSkin}/transparent.gif" width="20" height="1"/>
              </td>
            </tr>
            <tr>
              <td>
                <img src="{$mediaPathColumnBorder}/channeltopleftG.gif" width="20" height="13"/>
              </td>
              <td style="background-image: url({$mediaPathColumnBorder}/channeltopborderG.gif); background-repeat:repeat-x;">
                <img src="{$mediaPathSkin}/transparent.gif" width="1" height="13"/>
              </td>
              <td>
                <img src="{$mediaPathColumnBorder}/channeltoprightG.gif" width="20" height="13"/>
              </td>
            </tr>
            <tr>
              <td style="background-image: url({$mediaPathColumnBorder}/channelleftborderG.gif); background-repeat:repeat-y;">
                <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
              </td>
              <td valign="top" class="uportal-background-dark">
                <xsl:apply-templates>
                  <xsl:with-param name="type" select="'channel'"/>
                </xsl:apply-templates>
              </td>
              <td class="uportal-background-dark" style="background-image: url({$mediaPathColumnBorder}/channelrightborderG.gif); background-repeat:repeat-y;">
                <img src="{$mediaPathSkin}/transparent.gif" width="1" height="1"/>
              </td>
            </tr>
            <tr>
              <td>
                <img src="{$mediaPathColumnBorder}/bottomleftcornerG.gif" width="20" height="20"/>
              </td>
              <td style="background-image: url({$mediaPathColumnBorder}/bottomborderG.gif); background-repeat:repeat-x;">
                <img src="{$mediaPathSkin}/transparent.gif" width="1" height="8"/>
              </td>
              <td>
                <img src="{$mediaPathColumnBorder}/bottomrightcornerG.gif" width="20" height="20"/>
              </td>
            </tr>
          </table>
          <!-- End Column Table -->
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td valign="top" width="{@width}" class="uportal-background-dark">
          <xsl:apply-templates/>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="calculateShrinkColumn">
    <xsl:if test="number(substring-before(@width,'%'))&gt;4">
      <xsl:variable name="thisId" select="@ID"/>
      <xsl:choose>
        <xsl:when test="not(../column[position()=last()]/@ID=$thisId)">
          <xsl:variable name="thisColumnCondensed" select="number(substring-before(@width,'%'))-5"/>
          <xsl:variable name="followingColumnExpanded" select="number(substring-before(following-sibling::column/@width,'%'))+5"/>
          <input name="shrinkColumn" type="image" src="{$mediaPathIcons}/columnshrink.gif" width="28" height="25" border="0" alt="shrink this column by 5%" title="shrink this column by 5%"/>
          <input type="hidden" name="uP_sparam" value="mode"/>
          <input type="hidden" name="mode" value="{$mode}"/>
          <input type="hidden" name="uP_sparam" value="focusedTabID"/>
          <input type="hidden" name="focusedTabID" value="{$focusedTabID}"/>
          <input type="hidden" name="uP_sparam" value="selectedID"/>
          <input type="hidden" name="selectedID" value="no selectedID parameter"/>
          <input type="hidden" name="uP_sparam" value="targetRestriction"/>
          <input type="hidden" name="targetRestriction" value="no targetRestriction parameter"/>
          <input type="hidden" name="uP_sfattr" value="width"/>
          <input type="hidden" name="width_folderId" value="{@ID}"/>
          <input type="hidden" name="width_{@ID}_value" value="{$thisColumnCondensed}%"/>
          <input type="hidden" name="uP_sfattr" value="width"/>
          <input type="hidden" name="width_folderId" value="{following-sibling::column/@ID}"/>
          <input type="hidden" name="width_{following-sibling::column/@ID}_value" value="{$followingColumnExpanded}%"/>
        </xsl:when>
        <xsl:when test="../column[position()=last()]/@ID=$thisId">
          <xsl:variable name="thisColumnCondensed" select="number(substring-before(@width,'%'))-5"/>
          <xsl:variable name="precedingColumnExpanded" select="number(substring-before(preceding-sibling::column/@width,'%'))+5"/>
          <input name="shrinkColumn" type="image" src="{$mediaPathIcons}/columnshrink.gif" width="28" height="25" border="0" alt="shrink this column by 5%" title="shrink this column by 5%"/>
          <input type="hidden" name="uP_sparam" value="mode"/>
          <input type="hidden" name="mode" value="{$mode}"/>
          <input type="hidden" name="uP_sparam" value="focusedTabID"/>
          <input type="hidden" name="focusedTabID" value="{$focusedTabID}"/>
          <input type="hidden" name="uP_sparam" value="selectedID"/>
          <input type="hidden" name="selectedID" value="no selectedID parameter"/>
          <input type="hidden" name="uP_sparam" value="targetRestriction"/>
          <input type="hidden" name="targetRestriction" value="no targetRestriction parameter"/>
          <input type="hidden" name="uP_sfattr" value="width"/>
          <input type="hidden" name="width_folderId" value="{@ID}"/>
          <input type="hidden" name="width_{@ID}_value" value="{$thisColumnCondensed}%"/>
          <input type="hidden" name="uP_sfattr" value="width"/>
          <input type="hidden" name="width_folderId" value="{preceding-sibling::column/@ID}"/>
          <input type="hidden" name="width_{preceding-sibling::column/@ID}_value" value="{$precedingColumnExpanded}%"/>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="calculateExpandColumn">
    <xsl:if test="number(substring-before(@width,'%'))&lt;96">
      <xsl:variable name="thisId" select="@ID"/>
      <xsl:choose>
        <xsl:when test="not(../column[position()=last()]/@ID=$thisId)">
          <xsl:variable name="thisColumnExpanded" select="number(substring-before(@width,'%'))+5"/>
          <xsl:variable name="followingColumnCondensed" select="number(substring-before(following-sibling::column/@width,'%'))-5"/>
          <input name="expandColumn" type="image" src="{$mediaPathIcons}/columnexpand.gif" width="28" height="25" border="0" alt="expand this column by 5%" title="expand this column by 5%"/>
          <input type="hidden" name="uP_sparam" value="mode"/>
          <input type="hidden" name="mode" value="{$mode}"/>
          <input type="hidden" name="uP_sparam" value="focusedTabID"/>
          <input type="hidden" name="focusedTabID" value="{$focusedTabID}"/>
          <input type="hidden" name="uP_sparam" value="selectedID"/>
          <input type="hidden" name="selectedID" value="no selectedID parameter"/>
          <input type="hidden" name="uP_sparam" value="targetRestriction"/>
          <input type="hidden" name="targetRestriction" value="no targetRestriction parameter"/>
          <input type="hidden" name="uP_sfattr" value="width"/>
          <input type="hidden" name="width_folderId" value="{@ID}"/>
          <input type="hidden" name="width_{@ID}_value" value="{$thisColumnExpanded}%"/>
          <input type="hidden" name="uP_sfattr" value="width"/>
          <input type="hidden" name="width_folderId" value="{following-sibling::column/@ID}"/>
          <input type="hidden" name="width_{following-sibling::column/@ID}_value" value="{$followingColumnCondensed}%"/>
        </xsl:when>
        <xsl:when test="../column[position()=last()]/@ID=$thisId">
          <xsl:variable name="thisColumnExpanded" select="number(substring-before(@width,'%'))+5"/>
          <xsl:variable name="precedingColumnCondensed" select="number(substring-before(preceding-sibling::column/@width,'%'))-5"/>
          <input name="expandColumn" type="image" src="{$mediaPathIcons}/columnexpand.gif" width="28" height="25" border="0" alt="expand this column by 5%" title="expand this column by 5%"/>
          <input type="hidden" name="uP_sparam" value="mode"/>
          <input type="hidden" name="mode" value="{$mode}"/>
          <input type="hidden" name="uP_sparam" value="focusedTabID"/>
          <input type="hidden" name="focusedTabID" value="{$focusedTabID}"/>
          <input type="hidden" name="uP_sparam" value="selectedID"/>
          <input type="hidden" name="selectedID" value="no selectedID parameter"/>
          <input type="hidden" name="uP_sparam" value="targetRestriction"/>
          <input type="hidden" name="targetRestriction" value="no targetRestriction parameter"/>
          <input type="hidden" name="uP_sfattr" value="width"/>
          <input type="hidden" name="width_folderId" value="{@ID}"/>
          <input type="hidden" name="width_{@ID}_value" value="{$thisColumnExpanded}%"/>
          <input type="hidden" name="uP_sfattr" value="width"/>
          <input type="hidden" name="width_folderId" value="{preceding-sibling::column/@ID}"/>
          <input type="hidden" name="width_{preceding-sibling::column/@ID}_value" value="{$precedingColumnCondensed}%"/>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="normalizeColumnWidths">
    <form name="form_normalizeColumnWidths" method="post" action="{$baseActionURL}">
      <td>
        <input name="normalizeColumnWidths" type="image" src="{$mediaPathIcons}/columnnormalize.gif" width="28" height="25" border="0" alt="Reset column widths" title="Reset column widths"/>
        <input type="hidden" name="uP_sparam" value="mode"/>
        <input type="hidden" name="mode" value="{$mode}"/>
        <input type="hidden" name="uP_sparam" value="focusedTabID"/>
        <input type="hidden" name="focusedTabID" value="{$focusedTabID}"/>
        <input type="hidden" name="uP_sparam" value="selectedID"/>
        <input type="hidden" name="selectedID" value="no selectedID parameter"/>
        <input type="hidden" name="uP_sparam" value="targetRestriction"/>
        <input type="hidden" name="targetRestriction" value="no targetRestriction parameter"/>
        <xsl:for-each select="../column">
          <xsl:choose>
            <xsl:when test="not(round(100 mod number((count(../column))))=0) and position()=1">
              <input type="hidden" name="uP_sfattr" value="width"/>
              <input type="hidden" name="width_folderId" value="{@ID}"/>
              <input type="hidden" name="width_{@ID}_value" value="{round(100 div number((count(../column))))+1}%"/>
            </xsl:when>
            <xsl:otherwise>
              <input type="hidden" name="uP_sfattr" value="width"/>
              <input type="hidden" name="width_folderId" value="{@ID}"/>
              <input type="hidden" name="width_{@ID}_value" value="{round(100 div number((count(../column))))}%"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </td>
    </form>
  </xsl:template>
</xsl:stylesheet>
