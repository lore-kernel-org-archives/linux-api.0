From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Fri, 12 May 2017 08:15:49 +0100
Message-ID: <20170512071549.GP390@ZenIV.linux.org.uk>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170512070012.7dysuhbkcas7ibaj@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170512070012.7dysuhbkcas7ibaj@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

On Fri, May 12, 2017 at 09:00:12AM +0200, Ingo Molnar wrote:

> > How about trying to remove all of them?  If we could actually get rid
> > of all of them, we could drop the arch support, and we'd get faster,
> > simpler, shorter uaccess code throughout the kernel.
> 
> I'm all for that!

Oh, for...  Ingo, do you really want to go through all ->write() and ->read()
instances, converting all of them to iov_iter?  Or, better yet, deal with
the patch flood from Nick Krause sock puppet brigade?

Folks, seriously, have you even looked through that zoo?  I have, and it's
really, really not fun.  Sure, we can say "fuck 'em, no need to allow
splice() on random crap".  Would be perfectly reasonable, expect that
it's not the only place doing kernel_write() and its ilk...

And converting everything to ->read_iter()/->write_iter() means an insane
amount of code churn, not to mention coping with random bogosities in
semantics.  ->read() and ->write() are going to stay around, pretty
much indefinitely.
