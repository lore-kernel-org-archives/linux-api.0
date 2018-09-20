From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [RFC 02/20] timens: Add timens_offsets
Date: Fri, 21 Sep 2018 01:14:48 +0300
Message-ID: <20180920221448.GE20786@uranus>
References: <20180919205037.9574-1-dima@arista.com>
 <20180919205037.9574-3-dima@arista.com>
 <20180920184510.GC20786@uranus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180920184510.GC20786@uranus>
Sender: linux-kernel-owner@vger.kernel.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 20, 2018 at 09:45:10PM +0300, Cyrill Gorcunov wrote:
> On Wed, Sep 19, 2018 at 09:50:19PM +0100, Dmitry Safonov wrote:
> > From: Andrei Vagin <avagin@openvz.org>
> > 
> > Introduce offsets for time namespace. They will contain adjustment
> > needed to convert clocks to/from host's.
> > 
> > Allocate one page for each time namespace that will be premapped into
> > userspace with vvar pages.
> 
> Is not it too much?! The whole page per each clone(new-time-ns) call.
> Moreover everytime it is get explicitly zeroifyed. Don't get me wrong,
> maybe I miss something obvious, but additional 4K per process, guys :)

After being talking to Andrew I think there is no better option though.
If syscalls would be free of course we could use them instead but this
vdso stuff, sigh. I thouhgh about modifying vdso code so it would carry
refs inside (or adding some section into elf loader kernel code), but
all this would simply mess the code. Thus this 4K per namespace seems
to be acceptable trade off.
