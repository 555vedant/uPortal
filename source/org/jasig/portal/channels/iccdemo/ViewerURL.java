package org.jasig.portal.channels.iccdemo;

/**
 * A simple proxy class that CViewer binds in its jndi context.
 * Class allows outsiders to invoke URL change.
 *
 * @author <a href="mailto:pkharchenko@interactivebusiness.com">Peter Kharchenko</a>
 * @version $Revision$
 */
public class ViewerURL {
    private CViewer viewerChannel;
    public ViewerURL(CViewer channel) {
        this.viewerChannel=channel;
    }

    public void setNewURL(String newURL) {
        viewerChannel.changeURL(newURL);
    }
}
