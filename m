From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2 0/2] vfs: Define new syscall getumask.
Date: Thu, 14 Apr 2016 12:26:16 -0700
Message-ID: <20160414192616.GE20512@kroah.com>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com>
 <20160413135950.GA12128@kroah.com>
 <20160413234703.615f3016@grimm.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160413234703.615f3016@grimm.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Richard W.M. Jones" <rjones@redhat.com>, linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, luto@kernel.org, viro@zeniv.linux.org.uk, mathieu.desnoyers@efficios.com, zab@redhat.com, emunson@akamai.com, paulmck@linux.vnet.ibm.com, aarcange@redhat.com, josh@joshtriplett.org, xemul@parallels.com, sfr@canb.auug.org.au, milosz@adfin.com, arnd@arndb.de, ebiederm@xmission.com, gorcunov@openvz.org, iulia.manda21@gmail.com, dave.hansen@linux.intel.com, mguzik@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, linux-api@vger.kernel.org, gorcunov@gmail.com, fw@deneb.enyo.de
List-Id: linux-api@vger.kernel.org

On Wed, Apr 13, 2016 at 11:47:03PM -0400, Steven Rostedt wrote:
> On Wed, 13 Apr 2016 06:59:50 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> 
> > Why not add this to the ktest infrastructure, we strongly encourage that
> > for new syscalls, along with a man page patch.
> 
> Do you mean the "selftest infrastructure"? As I don't see how this
> could be used with ktest.
> 
> See tools/testing/selftests/

Sorry, yes, I meant selftest, not ktest, sorry for the confusion.

greg k-h
