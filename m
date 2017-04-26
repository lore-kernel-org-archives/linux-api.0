From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] uapi: remove false assertion that statx_timestamp.tv_nsec can be negative
Date: Wed, 26 Apr 2017 11:55:25 +0100
Message-ID: <13744.1493204125@warthog.procyon.org.uk>
References: <20170422192743.GA17005@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170422192743.GA17005@altlinux.org>
Content-ID: <13743.1493204125.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
List-Id: linux-api@vger.kernel.org

Dmitry V. Levin <ldv@altlinux.org> wrote:

> remove false assertion

It's not a false assertion.  I defined the statx interface that way.

> The best fix for this source of confusion is to change the type
> of struct statx_timestamp.tv_nsec from __s32 to __u32 .

Okay, if we're going to do the comment change, we should effect the type
change also.  Do you want to update your patch?

David
