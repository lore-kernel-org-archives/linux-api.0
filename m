From: Beata Michalska <b.michalska-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC v2 0/4] fs: Add generic file system event notifications
Date: Mon, 27 Apr 2015 13:51:40 +0200
Message-ID: <1430135504-24334-1-git-send-email-b.michalska@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kmpark-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi All,

This series is a follow-up of the RFC patchset for generic filesystem
events interface [1]. As there have been some rather significant changes
to the synchronization method being used, more extensive testing (stress
testing) has been performed (thus the delay).

Changes from v1:
	- Improved synchronization: switched to RCU accompanied with
	  ref counting mechanism
	- Limiting scope of supported event types along with default
	  event codes
	- Slightly modified configuration (event types followed by arguments
	  where required)
	- Updated documentation
	- Unified naming for netlink attributes
	- Updated netlink message format to include dev minor:major numbers
	  despite the filesystem type
	- Switched to single cmd id for messages
	- Removed the per-config-entry ids

---
[1] https://lkml.org/lkml/2015/4/15/46
---


Beata Michalska (4):
  fs: Add generic file system event notifications
  ext4: Add helper function to mark group as corrupted
  ext4: Add support for generic FS events
  shmem: Add support for generic FS events

 Documentation/filesystems/events.txt |  231 ++++++++++
 fs/Makefile                          |    1 +
 fs/events/Makefile                   |    6 +
 fs/events/fs_event.c                 |  770 ++++++++++++++++++++++++++++++++++
 fs/events/fs_event.h                 |   25 ++
 fs/events/fs_event_netlink.c         |   99 +++++
 fs/ext4/balloc.c                     |   25 +-
 fs/ext4/ext4.h                       |   10 +
 fs/ext4/ialloc.c                     |    5 +-
 fs/ext4/inode.c                      |    2 +-
 fs/ext4/mballoc.c                    |   17 +-
 fs/ext4/resize.c                     |    1 +
 fs/ext4/super.c                      |   39 ++
 fs/namespace.c                       |    1 +
 include/linux/fs.h                   |    6 +-
 include/linux/fs_event.h             |   58 +++
 include/uapi/linux/fs_event.h        |   54 +++
 include/uapi/linux/genetlink.h       |    1 +
 mm/shmem.c                           |   33 +-
 net/netlink/genetlink.c              |    7 +-
 20 files changed, 1357 insertions(+), 34 deletions(-)
 create mode 100644 Documentation/filesystems/events.txt
 create mode 100644 fs/events/Makefile
 create mode 100644 fs/events/fs_event.c
 create mode 100644 fs/events/fs_event.h
 create mode 100644 fs/events/fs_event_netlink.c
 create mode 100644 include/linux/fs_event.h
 create mode 100644 include/uapi/linux/fs_event.h

-- 
1.7.9.5
