From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 4/4] test: add a test for the process_vmsplice syscall
Date: Thu, 23 Nov 2017 16:07:25 +0200
Message-ID: <20171123140725.GC2303@rapoport-lnx>
References: <1511379391-988-1-git-send-email-rppt@linux.vnet.ibm.com>
 <1511379391-988-5-git-send-email-rppt@linux.vnet.ibm.com>
 <20171123080103.GA490@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171123080103.GA490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, criu@openvz.org, Arnd Bergmann <arnd@arndb.de>, Pavel Emelyanov <xemul@virtuozzo.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Josh Triplett <josh@joshtriplett.org>, Jann Horn <jannh@google.com>, Andrei Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 23, 2017 at 09:01:03AM +0100, Greg KH wrote:
> On Wed, Nov 22, 2017 at 09:36:31PM +0200, Mike Rapoport wrote:
> > From: Andrei Vagin <avagin@openvz.org>
> > 
> > This test checks that process_vmsplice() can splice pages from a remote
> > process and returns EFAULT, if process_vmsplice() tries to splice pages
> > by an unaccessiable address.
> > 
> > Signed-off-by: Andrei Vagin <avagin@openvz.org>
> > ---
> >  tools/testing/selftests/process_vmsplice/Makefile  |   5 +
> >  .../process_vmsplice/process_vmsplice_test.c       | 188 +++++++++++++++++++++
> >  2 files changed, 193 insertions(+)
> >  create mode 100644 tools/testing/selftests/process_vmsplice/Makefile
> >  create mode 100644 tools/testing/selftests/process_vmsplice/process_vmsplice_test.c
> > 

[ ... ]

> 
> Shouldn't you check to see if the syscall is even present?  You should
> not error if it is not, as this test will then "fail" on kernels/arches
> without the syscall enabled, which isn't the nicest.

Sure, will fix.

> thanks,
> 
> greg k-h
> 

-- 
Sincerely yours,
Mike.
