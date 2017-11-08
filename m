From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: MPK: pkey_free and key reuse
Date: Wed, 8 Nov 2017 12:41:30 -0800
Message-ID: <e7d1e622-bbac-2750-2895-cc151458ff2f@linux.intel.com>
References: <0f006ef4-a7b5-c0cf-5f58-d0fd1f911a54@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <0f006ef4-a7b5-c0cf-5f58-d0fd1f911a54@redhat.com>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>, linux-x86_64@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 11/05/2017 02:35 AM, Florian Weimer wrote:
> I don't think pkey_free, as it is implemented today, is very safe due to
> key reuse by a subsequent pkey_alloc.  I see two problems:
> 
> (A) pkey_free allows reuse for they key while there are still mappings
> that use it.

I don't agree with this assessment.  Is malloc() unsafe?  If someone
free()s memory that is still in use, a subsequent malloc() would hand
the address out again for reuse.

> (B) If a key is reused, existing threads retain their access rights,
> while there is an expectation that pkey_alloc denies access for the
> threads except the current one.
Where does this expectation come from?  Using the malloc() analogy, we
don't expect that free() in one thread actively takes away references to
the memory held by other threads.

We define free() as only being called on resources to which there are no
active references.  If you free() things in use, bad things happen.
pkey_free() is only to be called when there is nothing actively using
the key.  If you pkey_free() an in-use key, bad things happen.
