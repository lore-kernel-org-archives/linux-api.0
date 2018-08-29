From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v5 1/5] seccomp: add a return code to trap to userspace
Date: Wed, 29 Aug 2018 15:21:27 -0600
Message-ID: <20180829212127.GA15213@cisco.cisco.com>
References: <20180828143603.8127-1-tycho@tycho.ws>
 <20180828143603.8127-2-tycho@tycho.ws>
 <20180829185917.zj3gqyn6qf62sx66@mailbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180829185917.zj3gqyn6qf62sx66@mailbox.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, "Eric W . Biederman" <ebiederm@xmission.com>, Christian Brauner <christian.brauner@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 29, 2018 at 08:59:18PM +0200, Christian Brauner wrote:
> On Tue, Aug 28, 2018 at 08:35:59AM -0600, Tycho Andersen wrote:
> > +Users can ``read()`` or ``poll()`` on a seccomp notification fd to receive a
> 
> You have changed this from read() to ioctl(), right?

Derp, yes. I'll re-write this bit. Thanks for the others, I'll fix
them too. It's not bike shedding if it's incorrect :)

Thanks,

Tycho
