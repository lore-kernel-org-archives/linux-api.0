From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 1/2] fork: add clone3
Date: Sat, 1 Jun 2019 00:13:57 +0200
Message-ID: <20190531221356.uekyzxhtuijgj4pg@brauner.io>
References: <20190529152237.10719-1-christian@brauner.io>
 <20190529222414.GA6492@gmail.com>
 <CAHk-=whQP-Ykxi=zSYaV9iXsHsENa+2fdj-zYKwyeyed63Lsfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=whQP-Ykxi=zSYaV9iXsHsENa+2fdj-zYKwyeyed63Lsfw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrei Vagin <avagin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 31, 2019 at 01:38:29PM -0700, Linus Torvalds wrote:
> On Wed, May 29, 2019 at 3:24 PM Andrei Vagin <avagin@gmail.com> wrote:
> >
> > Thank you for thinking about time namespaces. I looked at this patch
> > quickly and I would suggest to move a termination signal out of flags. I
> > think we can add a separate field (exit_signal) into clone_args. Does it
> > make sense? For me, exit_signal in flags always looked weird...
> 
> I agree - the child signal in flags was always just a "it fits" kind
> of thing, and that was obviously true back then, but is not true now.

(Traveling until Monday, so sorry for delayed responses.)

Yip, I agree that this is a good idea (answered Andrei's mail just now
saying the same thing). I'll send out a new version of the patch with
these changes added next week.

Christian
