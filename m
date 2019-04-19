From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v3 4/4] samples: show race-free pidfd metadata access
Date: Fri, 19 Apr 2019 18:38:14 +0200
Message-ID: <20190419163813.okgqwmzahnt24vtm@brauner.io>
References: <20190419120904.27502-1-christian@brauner.io>
 <20190419120904.27502-5-christian@brauner.io>
 <20190419153047.GA12228@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190419153047.GA12228@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Jann Horn <jann@thejh.net>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 19, 2019 at 05:30:48PM +0200, Oleg Nesterov wrote:
> On 04/19, Christian Brauner wrote:
> >
> > +int main(int argc, char *argv[])
> > +{
> > +	int ret = EXIT_FAILURE;
> > +	char buf[4096] = { 0 };
> > +	pid_t pid;
> > +	int pidfd, procfd, statusfd;
> 
> I think you need to initialize pidfd = 0 in this version ;) Otherwise,

Yes, you are right. Seems I got saved by the compiler since I compile a
kernel and run a test even when i just change the commit message. :)
Will fix that up and add your Reviewed-by but I think I spare everyone
a v4 for this if that's ok.

> 
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>

Thank you!
Christian
