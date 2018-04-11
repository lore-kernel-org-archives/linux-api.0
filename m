From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 02/24] Add a SysRq option to lift kernel lockdown
Date: Wed, 11 Apr 2018 19:05:56 +0200
Message-ID: <CAG48ez2TN_fLgyiOZn5aTpKp9UTbJShO4iM=jHo3SJ7s6CW4Xg@mail.gmail.com>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346389240.4030.11187964053014260180.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <152346389240.4030.11187964053014260180.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, James Morris <jmorris@namei.org>, kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 11, 2018 at 6:24 PM, David Howells <dhowells@redhat.com> wrote:
> From: Kyle McMartin <kyle@redhat.com>
>
> Make an option to provide a sysrq key that will lift the kernel lockdown,
> thereby allowing the running kernel image to be accessed and modified.
>
> On x86 this is triggered with SysRq+x, but this key may not be available on
> all arches, so it is set by setting LOCKDOWN_LIFT_KEY in asm/setup.h.
> Since this macro must be defined in an arch to be able to use this facility
> for that arch, the Kconfig option is restricted to arches that support it.

In the current form, this is probably incompatible with USB/IP (which
Debian seems to be shipping as a module by default), right? And
perhaps also with dummy_hcd (if I understand correctly what it's
doing)?
