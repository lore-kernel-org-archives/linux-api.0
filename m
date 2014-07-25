From: Dave Jones <davej@redhat.com>
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Fri, 25 Jul 2014 16:15:07 -0400
Message-ID: <20140725201507.GA23410@redhat.com>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Julien Tinnes <jln@google.com>, David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Theodore Ts'o <tytso@mit.edu>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-crypto@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 25, 2014 at 11:30:48AM -0700, Andy Lutomirski wrote:

 > There is recent interest in having a way to turn generally-available
 > kernel features off.  Maybe we should add a good one so we can stop
 > bikeshedding and avoid proliferating dumb interfaces.
 > 
 > Things that might want to be turn-off-able include:
 >  - getrandom with GRND_RANDOM [from the getrandom threads]
 >  - Any lookup of a non-self pid [from the capsicum thread]
 >  - Any lookup of a pid outside the caller thread group [capsicum]
 >  - Various architectural things (personal wishlist), e.g.:
 >     - RDTSC and userspace HPET access
 >     - CPUID?
 >     - 32-bit GDT code segments [huge attack surface]
 >     - 64-bit GDT code segments [probably pointless]

I'm not sure there's value in disabling cpuid dev interface,
when the instruction is unprivileged.

 > I would propose a new syscall for this:
 > 
 > long restrict_userspace(int mode, int type, int value, int flags);

do the restrictions happen system-wide like in say SELinux,
or only within the calling process, like seccomp ?

	Dave
