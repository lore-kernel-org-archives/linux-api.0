From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 6/5] statx: add STATX_RESULT_MASK flag
Date: Sat, 20 Oct 2018 00:50:32 +0100
Message-ID: <2955.1539993032@warthog.procyon.org.uk>
References: <CAJfpegtPv4+QxzcqMAGwTt7QALjBaxQtt2Qet98pdmuT1MRUeA@mail.gmail.com> <20181019143932.6697-1-mszeredi@redhat.com> <18142.1539964788@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegtPv4+QxzcqMAGwTt7QALjBaxQtt2Qet98pdmuT1MRUeA@mail.gmail.com>
Content-ID: <2954.1539993032.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> This is very much about the basic statx fields.  I.e. what does
> result_mask == STATX_BASIC_STATS means?
> 
>  a) this is a legacy stat() implementation that doesn't fill in the
> result_mask properly
> 
>  b) this is an up-todate stat() implementation that does fill the
> result_mask properly and all fields are valid
> 
> There's no way to tell which one it is, and no way to request that
> filesystem try b) even if it's more costly.

Okay, I think I see what you're getting at.  We need to be able to tell the
user that we don't actually know what's good and what's not.  I guess this
doesn't only apply to fuse, but could also apply to nfs potentially as nfs
doesn't necessarily know what the server is capable of and where it's making
stuff up (imagine an NFS server backing both an ext4 and a fat filesystem).

I would be tempted to represent this with an attribute flag instead, say:

	STATX_ATTR_UNCERTAIN_VALUES

Your attributes are actually in one of at least three states, not two:
unsupported, definite and uncertain.  Definite things might include such as
STATX_TYPE - after all, if you don't know what type a file is, you can't
really use it.

If someone really needs to know, it might be worth deferring further
information to fsinfo().

David
