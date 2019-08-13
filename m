From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v8 09/27] mm/mmap: Prevent Shadow Stack VMA merges
Date: Tue, 13 Aug 2019 15:34:00 -0700
Message-ID: <5ba3d1b3-5587-e7dd-b9de-9a954172d31f@intel.com>
References: <20190813205225.12032-1-yu-cheng.yu@intel.com>
 <20190813205225.12032-10-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190813205225.12032-10-yu-cheng.yu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-api@vger.kernel.org

On 8/13/19 1:52 PM, Yu-cheng Yu wrote:
> To prevent function call/return spills into the next shadow stack
> area, do not merge shadow stack areas.

How does this prevent call/return spills?
