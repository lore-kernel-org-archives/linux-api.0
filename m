From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v4 06/31] richacl: In-memory representation and helper functions
Date: Fri, 26 Jun 2015 09:55:34 +0200
Message-ID: <CAHpGcM+Bf+ZhQEbKmtGhNMp2dJ8Btha7_gLi0Tu+Uk-zyCpQjg@mail.gmail.com>
References: <1435183040-22726-1-git-send-email-agruenba@redhat.com>
	<1435183040-22726-7-git-send-email-agruenba@redhat.com>
	<558C5D75.6050608@samba.org>
	<CAHpGcM+AwRubQqX96V3WbwLKXKTfk3YcgFG_eqG6r7cVbCTV-w@mail.gmail.com>
	<558C7535.9050502@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <558C7535.9050502-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2015-06-25 23:40 GMT+02:00 Stefan (metze) Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>>> I'm wondering if the size of an ace should be dynamic,
>>> which might make it possible to support other ace types
>>> in future. E.g. supporting other identities like 128-bit values
>>> to make it easier to map Windows SIDS.
>>
>> I'm working on additionally supporting unmapped user@domain and
>> group@domain identifier strings; we have to deal with that case in the
>> nfs client; that may be useful for Samba as well.
>
> Can this be any string? So would
> "S-1-5-21-4052121579-2079768045-1474639452-1001" also work?

I don't see why not, we'd just need to prevent namespace clashes.

> How would the current thread/process get a "token" that would match such
> an ace?

Solaris seems to solve this by what they call ephemeral ids; that concept may
become useful.

> [...]
> In general shouldn't kuid_t uid = current_fsuid(); be at the top of the
> function just once?

It really is just a pointer dereference.

Thanks,
Andreas
