/**
 * Copyright � 2003 The JA-SIG Collaborative.  All rights reserved.
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

package org.jasig.portal.i18n;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.jasig.portal.RDBMServices;
import org.jasig.portal.security.IPerson;
import org.jasig.portal.services.LogService;

/**
 * Database implementation of locale storage interface.
 * @author Ken Weiner, kweiner@unicon.net
 * @version $Revision$
 */
public class RDBMLocaleStore implements ILocaleStore {

    public Locale[] getUserLocales(IPerson person) throws Exception {
        List localeList = new ArrayList();
        Connection con = RDBMServices.getConnection();
        try {
            String query = "SELECT * FROM UP_USER_LOCALE WHERE USER_ID=? ORDER BY PRIORITY";
            RDBMServices.PreparedStatement pstmt = new RDBMServices.PreparedStatement(con, query);
            try {
                pstmt.clearParameters();
                pstmt.setInt(1, person.getID());
                LogService.log(LogService.DEBUG, query);
                ResultSet rs = pstmt.executeQuery();
                try {
                    while (rs.next()) {
                       String localeString = rs.getString("LOCALE");
                       Locale locale = LocaleManager.parseLocale(localeString);
                       localeList.add(locale);
                    }
                } finally {
                    rs.close();
                }
            } finally {
                pstmt.close();
            }
        } finally {
            RDBMServices.releaseConnection(con);
        } 
        return (Locale[])localeList.toArray(new Locale[0]); 
    }

    public void updateUserLocales(IPerson person, Locale[] locales) throws SQLException {
        Connection con = RDBMServices.getConnection();
        try {
            // Delete the existing list of locales
            String delete = "DELETE FROM UP_USER_LOCALE WHERE USER_ID=?";
            RDBMServices.PreparedStatement pstmt = new RDBMServices.PreparedStatement(con, delete);
            try {
                pstmt.clearParameters();
                pstmt.setInt(1, person.getID());
                LogService.log(LogService.DEBUG, delete);
                pstmt.executeUpdate();

            } finally {
                pstmt.close();
            }
            // Insert the new list of locales
            String insert = "INSERT INTO UP_USER_LOCALE VALUES (?, ?, ?)";
            pstmt = new RDBMServices.PreparedStatement(con, insert);
            try {
                for (int i = 0; i < locales.length; i++) {                        
                    pstmt.clearParameters();
                    pstmt.setInt(1, person.getID());
                    pstmt.setString(2, locales[i].toString());
                    pstmt.setInt(3, i);
                    LogService.log(LogService.DEBUG, insert);
                    pstmt.executeUpdate();
                } 

            } finally {
                pstmt.close();
            }            
        } finally {
            RDBMServices.releaseConnection(con);
        } 
    }
}
