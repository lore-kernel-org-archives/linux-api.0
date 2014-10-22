From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Wed, 22 Oct 2014 04:54:54 -0700
Message-ID: <20141022115454.GA9041@infradead.org>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
 <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
 <20141022115405.GA8593@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141022115405.GA8593@infradead.org>
Sender: linux-arch-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Drysdale <drysdale@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Rich Felker <dalias@aerifal.cx>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 22, 2014 at 04:54:05AM -0700, Christoph Hellwig wrote:
> [adding Rich Felker to the Cc list, who has been very interested in a
> O_SEARCH implementation for which this would be an important building
> block]

s/O_SEARCH/O_EXEC/, sorry.
