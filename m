From: nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org
Subject: Re: [RFC PATCH 1/2] security, capabilities: create CAP_TRUSTED
Date: Sat, 21 Oct 2017 21:09:32 +0200
Message-ID: <201710211909.v9LJ9Zg8033866__37342.838155064$1508613160$gmane$org@smtp6.infomaniak.ch>
References: <20171021134558.21195-1-nicolas@belouin.fr> <20171021160302.GA2842@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171021160302.GA2842-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <yuchao0-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Fasheh <mfasheh-rOS7oXVqrJRBDgjK7y7TUQ@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Phillip Lougher <phillip-Y7wUz+saRi+tmTQ+vhA3Yw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Adrian Hunter <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, James.Morris-YwJKx0arFUy+Po31K3cvAx+/fu+cuQ+V@public.gmane.org
List-Id: linux-api@vger.kernel.org

<james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org,linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org,linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
From: Nicolas Belouin <nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>
Message-ID: <99179B10-4EAE-4FAB-9D14-B885156261B3-6zwZCx3K5ONGWvitb5QawA@public.gmane.org>



On October 21, 2017 6:03:02 PM GMT+02:00, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
>Quoting Nicolas Belouin (nicolas-6zwZCx3K5ONGWvitb5QawA@public.gmane.org):
>> with CAP_SYS_ADMIN being bloated, the usefulness of using it to
>> flag a process to be entrusted for e.g reading and writing trusted
>> xattr is near zero.
>> CAP_TRUSTED aims to provide userland with a way to mark a process as
>> entrusted to do specific (not specially admin-centered) actions. It
>> would for example allow a process to red/write the trusted xattrs.
>
>You say "for example".  Are you intending to add more uses?  If so,
>what
>are they?  If not, how about renaming it CAP_TRUSTED_XATTR?
>

I don't see any other use for now, but I don't want it to be too narrow and non usable in a similar context in the future. So I believe the underlying purpose of marking a process as "trusted" (even if for now it only means rw permission on trusted xattr) is more meaningful.

>What all does allowing writes to trusted xattrs give you?  There are
>the overlayfs whiteouts, what else?

Nicolas
