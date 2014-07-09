From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Date: Wed, 9 Jul 2014 01:48:59 -0700
Message-ID: <20140709084859.GA4618@infradead.org>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com>
 <20140708120331.GA30459@infradead.org>
 <CAHse=S-gBbYe65mo6tBSJ2p=Z5aswgJTFvt9r29aHP3ALfJ0Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHse=S-gBbYe65mo6tBSJ2p=Z5aswgJTFvt9r29aHP3ALfJ0Mw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, LSM List <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 08, 2014 at 05:54:24PM +0100, David Drysdale wrote:
> > How is this implemented in FreeBSD?  I can't find any references to
> > O_BENEATH_ONLY except for your patchset.
> 
> FreeBSD have the relative-only behaviour for openat() relative to a
> Capsicum capability dfd [1], and for a process in capability-mode [2],
> but they don't have the O_BENEATH_ONLY as a separately-accessible
> openat() flag.  However, it seemed like a more widely useful idea so
> separating it out was suggested.

In that case we should make sure to use the same name and semantics for
it.  As far as I'm concerned I'd prefer a less clumsy name like
O_BENEATH.
