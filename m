From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 12/13] Hide AT_VECTOR_SIZE_ARCH behind #ifdef __KERNEL__
Date: Thu, 10 Sep 2015 12:14:06 +0100
Message-ID: <18120.1441883646@warthog.procyon.org.uk>
References: <1441832902-28993-13-git-send-email-palmer@dabbelt.com> <2644177.lVCYzIBfPW@wuerfel> <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1441832902-28993-13-git-send-email-palmer@dabbelt.com>
Content-ID: <18119.1441883646.1@warthog.procyon.org.uk>
Sender: netdev-owner@vger.kernel.org
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: dhowells@redhat.com, arnd@arndb.de, 3chas3@gmail.com, hpa@zytor.com, mingo@redhat.com, plagnioj@jcrosoft.com, jikos@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-atm-general@lists.sourceforge.net, linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tglx@linutronix.de, tomi.valkeinen@ti.com, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Palmer Dabbelt <palmer@dabbelt.com> wrote:

> I think this actually isn't a good idea, but I can't find anything
> outside of the kernel that's using this so I'm going to hide it.

It should be in arch/x86/include/asm/auxvec.h then.
