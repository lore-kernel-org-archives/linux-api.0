From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v4 02/27] x86/fpu/xstate: Change some names to
 separate XSAVES system and user states
Date: Tue, 02 Oct 2018 09:21:18 -0700
Message-ID: <ba13d643c21de8e1e01a8d528457fb5dd82c42aa.camel@intel.com>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com>
         <20180921150351.20898-3-yu-cheng.yu@intel.com>
         <20181002152903.GB29601@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002152903.GB29601@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On Tue, 2018-10-02 at 17:29 +0200, Borislav Petkov wrote:
> On Fri, Sep 21, 2018 at 08:03:26AM -0700, Yu-cheng Yu wrote:
> > To support XSAVES system states, change some names to distinguish
> > user and system states.
> 
> I don't understand what the logic here is. SDM says:
> 
> XSAVES—Save Processor Extended States Supervisor
> 
> the stress being on "Supervisor" - why does it need to be renamed to
> "system" now?
> 

Good point.  However, "system" is more indicative; CET states are per-task and
not "Supervisor".  Do we want to go back to "Supervisor" or add comments?

Yu-cheng
