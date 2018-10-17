From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 31/34] vfs: syscall: Add fspick() to select a superblock for reconfiguration [ver #12]
Date: Wed, 17 Oct 2018 14:15:01 +0100
Message-ID: <19866.1539782101@warthog.procyon.org.uk>
References: <68a2107f-bf70-055b-86cf-1ba2ba9422bf@gmail.com> <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk> <153754766004.17872.9829232103614083565.stgit@warthog.procyon.org.uk> <9b8bf436-65de-13b9-0002-0479d11c18ca@gmail.com> <20181013061141.GR32577@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <68a2107f-bf70-055b-86cf-1ba2ba9422bf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>, linux-api@vger.kernel.org, torvalds@linux-foundation.org, ebiederm@xmission.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

Alan Jenkins <alan.christopher.jenkins@gmail.com> wrote:

> Sorry, I guess SB_NOUSER was the wrong word.  I was trying find if anything
> stopped things like
> 
> int memfd = memfd_create("foo", 0);
> int fsfd = fspick(memfd, "", FSPICK_EMPTY_PATH);
> 
> fsconfig(fsfd, FSCONFIG_SET_FLAG, "ro", NULL, 0);
> fsconfig(fsfd, FSCONFIG_SET_STRING, "size", "100M", 0);
> fsconfig(fsfd, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0);
> 
> So far I'm getting -EBUSY if I try to apply the "ro", -EINVAL if I try to
> apply the "size=100M".  But if I don't apply either, then
> FSCONFIG_CMD_RECONFIGURE succeeds.

I should probably check that the picked point is actually a mountpoint.

David
