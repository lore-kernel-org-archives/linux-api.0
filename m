From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v4 09/27] x86/mm: Change _PAGE_DIRTY to
 _PAGE_DIRTY_HW
Date: Wed, 03 Oct 2018 09:07:52 -0700
Message-ID: <a278be878c9a1bdbe9adea515fcca5a691db17aa.camel@intel.com>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com>
         <20180921150351.20898-10-yu-cheng.yu@intel.com>
         <20181003133856.GA24782@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181003133856.GA24782@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On Wed, 2018-10-03 at 06:38 -0700, Matthew Wilcox wrote:
> On Fri, Sep 21, 2018 at 08:03:33AM -0700, Yu-cheng Yu wrote:
> > We are going to create _PAGE_DIRTY_SW for non-hardware, memory
> > management purposes.  Rename _PAGE_DIRTY to _PAGE_DIRTY_HW and
> > _PAGE_BIT_DIRTY to _PAGE_BIT_DIRTY_HW to make these PTE dirty
> > bits more clear.  There are no functional changes in this
> > patch.
> 
> I would like there to be some documentation in this patchset which
> explains the difference between PAGE_SOFT_DIRTY and PAGE_DIRTY_SW.

I will add some comments for the difference between PAGE_SOFT_DIRTY and
PAGE_DIRTY_SW.

Yu-cheng
