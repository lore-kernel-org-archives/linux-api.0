From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/6] fsinfo: Add mount topology query [ver #15]
Date: Fri, 28 Jun 2019 16:46:58 +0100
Message-ID: <156173681842.14728.9331700785061885270.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, raven@themaw.net, mszeredi@redhat.com, christian@brauner.io, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


Here's a set of patches that builds upon the previously posted fsinfo()
interface to:

 (a) Make it possible to invoke a query based on a mount ID rather than a
     path.  This is done by setting AT_FSINFO_MOUNTID_PATH and pointing the
     pathname argument to the mount ID as a string.

     A pathname is not a unique handle into the mount topology tree.  It's
     possible for there to be multiple overlying mounts at any particular
     point in the tree, and only the topmost can be directly accessed (the
     bottom might be inferrable from the parent).

     Usage of the mount ID permits all mount objects to be queried.  It
     would be possible to restrict the query based on the method used to
     address the object, though I haven't done this for now.

 (b) Provide a change ID for each mount object that is incremented each
     time a change is applied to that mount object.

 (c) Allow the mount topology to be queried.  The mount topology
     information returned is sprinkled with change IDs to make it easier to
     check for changes during multiple queries.  A future notification
     mechanism will also help with this.

 (d) Provide a system-unique superblock identifier that can be used to
     check to see if a mount object references the same superblock as it
     used to or as another mount object without relying on device numbers -
     which might not be seen to change over an unmount-mount combo.

A sample is also provided that allows the mount topology tree at a point to
be listed.

The patches can be found here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git

on branch:

	fsinfo-mount

[!] Note that this depends on the fsinfo branch.


===================
SIGNIFICANT CHANGES
===================

 ver #15:

 (*) Split from the fsinfo-core branch.

 (*) Rename notify_counter to change_counter as there's no notification
     stuff here (that's in separate branches).
