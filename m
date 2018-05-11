From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v5 0/7] proc: modernize proc to support multiple private
 instances
Date: Fri, 11 May 2018 20:28:32 +0100
Message-ID: <20180511192831.GC30522@ZenIV.linux.org.uk>
References: <20180511093221.GA902@comp-core-i7-2640m-0182e6>
 <CA+55aFwZK+BMsm19sK-Wmfta6PcdvW6z-ghuKsb4PAwk19nRVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwZK+BMsm19sK-Wmfta6PcdvW6z-ghuKsb4PAwk19nRVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: gladkov.alexey@gmail.com, Kees Cook <keescook@chromium.org>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "J. Bruce Fields" <bf>
List-Id: linux-api@vger.kernel.org

On Fri, May 11, 2018 at 09:39:23AM -0700, Linus Torvalds wrote:
> On Fri, May 11, 2018 at 2:42 AM Alexey Gladkov <gladkov.alexey@gmail.com>
> wrote:
> 
> > This is RFC v5 to modernize procfs and make it able to support multiple
> > private instances per the same pid namespace.
> 
> So I have no big objections, but I would *really* like this to go through
> Al's vfs tree.
> 
> Al? Have you looked at this series?

Looking through it...
