From: Steve French <smfrench@gmail.com>
Subject: Re: [RFC PATCH 00/27] Containers and using authenticated filesystems
Date: Wed, 20 Feb 2019 12:54:17 -0600
Message-ID: <CAH2r5muChuoHAM-AhBhTRkp=Lz0onyPa63MpV0qgm1TQKF=R5Q@mail.gmail.com>
References: <155024683432.21651.14153938339749694146.stgit@warthog.procyon.org.uk>
 <8736ojybw7.fsf@xmission.com> <22055.1550619729@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <22055.1550619729@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, keyrings@vger.kernel.org, trond.myklebust@hammerspace.com, Steve French <sfrench@samba.org>, linux-security-module@vger.kernel.org, linux-nfs@vger.kernel.org, CIFS <linux-cifs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, rgb@redhat.com, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 19, 2019 at 5:42 PM David Howells <dhowells@redhat.com> wrote:
>
> Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> > So you missed the main mailing lists for discussion of this kind of
> > thing
>
> Yeah, sorry about that.  I was primarily aiming it at Trond and Steve as I'd
> like to consider how to go about interpolating request_key() into NFS and CIFS
> so that they can make use of the key-related facilities that this makes
> available with AFS.

I am interested in this discussion because I have gotten various questions
about using Containers better on SMB3 mounts, and the question about
doing request_key better comes up **a lot** on SMB3 mounts (not just
for kerberos, Active Directory), and usability could be improved of some
of the cifs-utils that cifs.ko depends on.

Note that various virtualization/container identify features were added to the
protocol a few years ago (which we don't yet implement in Linux) but which
probably be **very** useful to followup on how these could be exposed
to help containers on network mounts in Linux.    See in particular this
new protocol feature (implemented by various servers including Windows
but not by Linux client yet) described in the protocol spec (MS-SMB2 section
2.2.9.2.1) - the "SMB2_REMOTED_IDENTITY_TREE_CONNECT context"
which can be sent at mount time:
https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/ee7ff411-93e0-484f-9f73-31916fee4cb8

This may be of interest to Samba server developers as well

> > and the maintainer.
>
> That would be me.  I maintain keyrings.


-- 
Thanks,

Steve
