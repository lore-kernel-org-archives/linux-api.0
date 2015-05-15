From: Zach Brown <zab@zabbo.net>
Subject: [PATCH RFC v2 0/2] O_NOCMTIME protected by generic mount option
Date: Fri, 15 May 2015 14:23:46 -0700
Message-ID: <1431725028-24071-1-git-send-email-zab@zabbo.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sage Weil <sweil@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Here's a current draft of what is now the O_NOCMTIME series.  It
implements the frequent suggestion to gate unprivileged O_NOCMTIME use
with a mount option.

This method has the advantage of being entirely runtime.  There's no
persistence that'd require updating all the tools that deal with each
file system's format.  It's also requested by writers as they open.
Writes to the file that know nothing of O_NOCMTIME will behave as
usual.

Another suggested method is to use inode attributes: require root to
set +nocmtime on a dir and inherit it down subdirs to new files.  This
nicely solves the unprivilieged use problem without having to fiddle
with mount options but it requires touching all systems that support
it and would prevent cmtime updates on all writes to the inode.  I
have a patch series that starts on this but haven't taken it very far.

Sage is working on spinning up some hardware to test the various dirty
inode avoidance methods at load and should have numbers soon.  That'll
tell us if lazytime isn't good enough and if any of this is worth the
trouble.

- z
