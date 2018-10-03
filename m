From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH v4 09/27] x86/mm: Change _PAGE_DIRTY to _PAGE_DIRTY_HW
Date: Wed, 3 Oct 2018 06:38:56 -0700
Message-ID: <20181003133856.GA24782@bombadil.infradead.org>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com>
 <20180921150351.20898-10-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180921150351.20898-10-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On Fri, Sep 21, 2018 at 08:03:33AM -0700, Yu-cheng Yu wrote:
> We are going to create _PAGE_DIRTY_SW for non-hardware, memory
> management purposes.  Rename _PAGE_DIRTY to _PAGE_DIRTY_HW and
> _PAGE_BIT_DIRTY to _PAGE_BIT_DIRTY_HW to make these PTE dirty
> bits more clear.  There are no functional changes in this
> patch.

I would like there to be some documentation in this patchset which
explains the difference between PAGE_SOFT_DIRTY and PAGE_DIRTY_SW.

Also, is it really necessary to rename PAGE_DIRTY?  It feels like a
lot of churn.
