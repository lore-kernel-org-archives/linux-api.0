From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Sun, 27 Jul 2014 17:06:17 -0400
Message-ID: <20140727210617.GY6725@thunk.org>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Julien Tinnes <jln@google.com>, David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-crypto@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 25, 2014 at 11:30:48AM -0700, Andy Lutomirski wrote:
> 
> There is recent interest in having a way to turn generally-available
> kernel features off.  Maybe we should add a good one so we can stop
> bikeshedding and avoid proliferating dumb interfaces.

I believe the seccomp infrastructure (which is already upstream)
should be able to do most of what you want, at least with respect to
features which are exposed via system calls (which was most of your
list).

It won't cover x86 specific things like restricting RDTSC or CPUID
(and as far as I know you can't intercept the CPUID instruction), but
I'm not sure it matters.  I don't really see the point, myself.

    	     		    	  	 - Ted
