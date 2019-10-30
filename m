From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Wed, 30 Oct 2019 11:01:53 -0700
Message-ID: <20a7ae04-877a-692e-0b8d-e1baee511090@intel.com>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
 <1572171452-7958-2-git-send-email-rppt@kernel.org>
 <20191028123124.ogkk5ogjlamvwc2s@box> <20191028130018.GA7192@rapoport-lnx>
 <20191028131623.zwuwguhm4v4s5imh@box>
 <20191028135521.GB4097@hirez.programming.kicks-ass.net>
 <0a35765f7412937c1775daa05177b20113760aee.camel@intel.com>
 <20191028210052.GM4643@worktop.programming.kicks-ass.net>
 <69c57f7fa9a1be145827673b37beff155a3adc3c.camel@intel.com>
 <20191030100418.GV4097@hirez.programming.kicks-ass.net>
 <b4d87f54b02cfccb58442f791485cad1ac080063.camel@intel.com>
 <775eb0cf-7189-a314-5dde-f720b56ec3b2@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <775eb0cf-7189-a314-5dde-f720b56ec3b2@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "peterz@infradead.org" <peterz@infradead.org>
Cc: "adobriyan@gmail.com" <adobriyan@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "luto@kernel.org" <luto@kernel.org>, "kirill@shutemov.name" <kirill@shutemov.name>, "bp@alien8.de" <bp@alien8.de>, "rppt@linux.ibm.com" <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On 10/30/19 10:58 AM, Dave Hansen wrote:
> Modules also require privilege.

IMNHO, if BPF is fracturing large swaths the direct map with no
privilege, it's only a matter of time until it starts to cause problems.
 The fact that we do it today is only evidence that we have a ticking
time bomb, not that it's OK.
