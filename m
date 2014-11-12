From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv7 0/3] syscalls,x86: Add execveat() system call
Date: Wed, 12 Nov 2014 13:50:09 -0800
Message-ID: <20141112135009.5a887d200be262d94ba50495@linux-foundation.org>
References: <1415379664-31555-1-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1415379664-31555-1-git-send-email-drysdale@google.com>
Sender: linux-arch-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>, x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri,  7 Nov 2014 17:01:01 +0000 David Drysdale <drysdale@google.com> wrote:

> This patch set adds execveat(2) for x86, and is derived from Meredydd
> Luff's patch from Sept 2012 (https://lkml.org/lkml/2012/9/11/528).
> 
> The primary aim of adding an execveat syscall is to allow an
> implementation of fexecve(3) that does not rely on the /proc
> filesystem, at least for executables (rather than scripts).  The
> current glibc version of fexecve(3) is implemented via /proc, which
> causes problems in sandboxed or otherwise restricted environments.

Have the relevant glibc people seen/reviewed/liked this?  
