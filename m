From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 04/10] pipe: Use head and tail pointers for the ring,
 not cursor and length [ver #2]
Date: Sun, 8 Dec 2019 10:10:51 -0800
Message-ID: <CAHk-=wgh9zUy9nbiCgGjtrgw1V9Vk=01Ncju-0iib5Jn-V1arw@mail.gmail.com>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <157186186167.3995.7568100174393739543.stgit@warthog.procyon.org.uk>
 <20191206214725.GA2108@latitude> <CAHk-=wga0MPEH5hsesi4Cy+fgaaKENMYpbg2kK8UA0qE3iupgw@mail.gmail.com>
 <20191207000015.GA1757@latitude> <CAHk-=wjEa5oNcQ9+9fai1Awqktf+hzz_HZmChi8HZJWcL62+Cw@mail.gmail.com>
 <20191208175602.GA1844@latitude>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191208175602.GA1844@latitude>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Hirte <johannes.hirte@datenkhaos.de>
Cc: David Howells <dhowells@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Dec 8, 2019 at 9:56 AM Johannes Hirte
<johannes.hirte@datenkhaos.de> wrote:
>
> whereas with a fresh cloned repo I get:
>
> v5.4-13331-g9455d25f4e3b
>
> I assume the later is right. With this version the bug seems to be
> fixed, regardless of the commit count. Tested with different websites
> and firefox works as expected again.

Ok, good. It was almost certainly the select/poll race fix - Mariusz
Ceier reported a problem with youtube hanging, and confirmed that the
poll/select fix seems to have cleared that one up. I suspect that your
hang on fb and spiegel.de were the same thing.

So I think the pipe code is stable again with current -git. Thanks for
reporting and testing,

             Linus
