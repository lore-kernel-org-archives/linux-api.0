From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v8 09/27] mm/mmap: Prevent Shadow Stack VMA merges
Date: Wed, 14 Aug 2019 09:20:21 -0700
Message-ID: <699fe0a2c2331af0d45a3516d9422d5ed5b59a99.camel@intel.com>
References: <20190813205225.12032-1-yu-cheng.yu@intel.com>
         <20190813205225.12032-10-yu-cheng.yu@intel.com>
         <5ba3d1b3-5587-e7dd-b9de-9a954172d31f@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5ba3d1b3-5587-e7dd-b9de-9a954172d31f@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-api@vger.kernel.org

On Tue, 2019-08-13 at 15:34 -0700, Dave Hansen wrote:
> On 8/13/19 1:52 PM, Yu-cheng Yu wrote:
> > To prevent function call/return spills into the next shadow stack
> > area, do not merge shadow stack areas.
> 
> How does this prevent call/return spills?

It does not.  I will fix the description.

Yu-cheng
