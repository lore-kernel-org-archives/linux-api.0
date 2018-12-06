From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 6 Dec 2018 16:27:46 -0600
Message-ID: <20181206222746.GB9224@mail.hallyn.com>
References: <20181206121858.12215-1-christian@brauner.io>
 <87sgzahf7k.fsf@xmission.com>
 <CAKOZuet4ayDu-54u2tO9tRDCgxa9JQ4avAiYS8xEtReN4MMhAA@mail.gmail.com>
 <878t12efg3.fsf@xmission.com>
 <20181206174129.taakmwekysbkaosu@brauner.io>
 <CAGXu5jL8PciZAXvOvCeCU3wKUEB_dU-O3q0tDw4uB_ojMvDEew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jL8PciZAXvOvCeCU3wKUEB_dU-O3q0tDw4uB_ojMvDEew@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Colascione <dancol@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 06, 2018 at 10:30:40AM -0800, Kees Cook wrote:
> On Thu, Dec 6, 2018 at 9:41 AM Christian Brauner <christian@brauner.io> wrote:
> > I feel changing the name around by a single persons preferences is not
> > really a nice thing to do community-wise. So I'd like to hear other
> > people chime in first before I make that change.
> 
> I don't think the name is hugely critical (but it's always the hardest
> to settle on). My preference order would be:
> 
> taskfd_send_signal()
> pidfd_send_signal()
> procfd_send_signal()
> fd_send_signal()

imo, either procfd_send_signal() or taskfd_send_signal()

It seems to me that using flags later to specify sending to pgrp vs thread
is fine:  it's specifying how to interpret the 'fd' in 'procfd_send_signal()'.

> But, agreed, I think fdkill() should not be used.
> 
> -- 
> Kees Cook
