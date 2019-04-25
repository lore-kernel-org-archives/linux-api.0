From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH V2] mm: Allow userland to request that the kernel clear
 memory on release
Date: Thu, 25 Apr 2019 14:40:48 +0200
Message-ID: <1df0ef0c-4219-c259-18a2-9abfb2782c08@suse.cz>
References: <CACdnJuup-y1xAO93wr+nr6ARacxJ9YXgaceQK9TLktE7shab1w@mail.gmail.com>
 <20190424211038.204001-1-matthewgarrett@google.com>
 <20190425121410.GC1144@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425121410.GC1144@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, Matthew Garrett <matthewgarrett@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 4/25/19 2:14 PM, Michal Hocko wrote:
> Please cc linux-api for user visible API proposals (now done). Keep the
> rest of the email intact for reference.
> 
> On Wed 24-04-19 14:10:39, Matthew Garrett wrote:
>> From: Matthew Garrett <mjg59@google.com>
>>
>> Applications that hold secrets and wish to avoid them leaking can use
>> mlock() to prevent the page from being pushed out to swap and
>> MADV_DONTDUMP to prevent it from being included in core dumps. Applications

So, do we really need a new madvise() flag and VMA flag, or can we just
infer this page clearing from mlock+MADV_DONTDUMP being both applied?
