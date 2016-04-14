From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 0/2] vfs: Define new syscall getumask.
Date: Wed, 13 Apr 2016 23:47:03 -0400
Message-ID: <20160413234703.615f3016@grimm.local.home>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com>
	<20160413135950.GA12128@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160413135950.GA12128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "Richard W.M. Jones" <rjones@redhat.com>, linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, luto@kernel.org, viro@zeniv.linux.org.uk, mathieu.desnoyers@efficios.com, zab@redhat.com, emunson@akamai.com, paulmck@linux.vnet.ibm.com, aarcange@redhat.com, josh@joshtriplett.org, xemul@parallels.com, sfr@canb.auug.org.au, milosz@adfin.com, arnd@arndb.de, ebiederm@xmission.com, gorcunov@openvz.org, iulia.manda21@gmail.com, dave.hansen@linux.intel.com, mguzik@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, linux-api@vger.kernel.org, gorcunov@gmail.com, fw@deneb.enyo.de
List-Id: linux-api@vger.kernel.org

On Wed, 13 Apr 2016 06:59:50 -0700
Greg KH <greg@kroah.com> wrote:


> Why not add this to the ktest infrastructure, we strongly encourage that
> for new syscalls, along with a man page patch.

Do you mean the "selftest infrastructure"? As I don't see how this
could be used with ktest.

See tools/testing/selftests/

-- Steve
