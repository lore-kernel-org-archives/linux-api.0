From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v4 23/27] mm/map: Add Shadow stack pages to memory
 accounting
Date: Fri, 21 Sep 2018 10:21:50 -0700
Message-ID: <c2d5d7944b7a34b67ddc0e5c1d3600e63c426236.camel@intel.com>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com>
         <20180921150351.20898-24-yu-cheng.yu@intel.com>
         <8c18fabf-170f-9010-3075-238e34c9f09b@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8c18fabf-170f-9010-3075-238e34c9f09b@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pave
List-Id: linux-api@vger.kernel.org

On Fri, 2018-09-21 at 09:55 -0700, Randy Dunlap wrote:
> On 9/21/18 8:03 AM, Yu-cheng Yu wrote:
> > Add shadow stack pages to memory accounting.
> > Also check if the system has enough memory before enabling CET.
> > 
> > Signed-off-by: Yu-cheng Yu <yu-cheng.yu.intel.com>
> 
> oops. typo above.
> 

I will fix it.  Thanks!
