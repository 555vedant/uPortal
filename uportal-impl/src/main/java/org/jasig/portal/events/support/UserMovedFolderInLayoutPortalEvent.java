package org.jasig.portal.events.support;

import org.jasig.portal.UserProfile;
import org.jasig.portal.events.EventType;
import org.jasig.portal.layout.node.IUserLayoutFolderDescription;
import org.jasig.portal.security.IPerson;

public final class UserMovedFolderInLayoutPortalEvent extends LayoutPortalEvent {
    private static final long serialVersionUID = 1L;

	public UserMovedFolderInLayoutPortalEvent(final Object source, final IPerson person, final UserProfile profile,
            final IUserLayoutFolderDescription folder) {
        super(source, person, profile, folder, EventType.getEventType("LAYOUT_FOLDER_MOVED"));
    }

    /* (non-Javadoc)
     * @see java.util.EventObject#toString()
     */
    @Override
	public String toString() {
		return "Folder " + getFolderString()
                + " was moved in layout " + getProfile().getLayoutId()
				+ " by " + getDisplayName() + "  at " + getTimestampAsDate();
	}
}
