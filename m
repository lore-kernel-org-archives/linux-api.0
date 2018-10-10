From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/5] VFS: Introduce filesystem information query syscall [ver #12]
Date: Wed, 10 Oct 2018 12:58:31 +0100
Message-ID: <30911.1539172711@warthog.procyon.org.uk>
References: <f3646774-ee9e-d5b7-8a11-670012034d59@rasmusvillemoes.dk> <153754786825.19213.16907802981157370740.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f3646774-ee9e-d5b7-8a11-670012034d59@rasmusvillemoes.dk>
Content-ID: <30910.1539172711.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> Would you consider adding a Kconfig knob to not include all this (and
> all the extra tricks that syscall might learn down the road)?

I guess that can be done, though the bits are spread out into various
filesystems.

David
