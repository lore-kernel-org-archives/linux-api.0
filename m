From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 05/13] Split FDPIC "struct elf_prstatus" to "struct elf_fdpic_prstatus"
Date: Thu, 17 Sep 2015 11:17:27 +0100
Message-ID: <16418.1442485047@warthog.procyon.org.uk>
References: <1442271047-4908-6-git-send-email-palmer@dabbelt.com> <1441832902-28993-1-git-send-email-palmer@dabbelt.com> <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1442271047-4908-6-git-send-email-palmer@dabbelt.com>
Content-ID: <16417.1442485047.1@warthog.procyon.org.uk>
Sender: linux-arch-owner@vger.kernel.org
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: dhowells@redhat.com, arnd@arndb.de, viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Palmer Dabbelt <palmer@dabbelt.com> wrote:

> I tried to fix all the users of "struct elf_prstatus" that should now
> be using "struct elf_fdpic_prstatus".  The only testing I did here was
> to build a Blackfin defconfig with "struct elf_prstatus" not defined,
> and to build an x86 defconfig with "struct elf_fdpic_prstatus" not
> defined.

You probably also need to try loading a core into a debugger.

David
