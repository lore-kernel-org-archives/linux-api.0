From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCHv3 1/2] proc: mm: export PTE sizes directly in smaps
Date: Thu, 26 Oct 2017 07:25:37 -0700
Message-ID: <10bc2525-fccc-81e6-1ec0-27d63cff89b4@intel.com>
References: <1508891255-15427-1-git-send-email-fan.du@intel.com>
 <20171025092838.4j4u4eeppzh6uto2@dhcp22.suse.cz>
 <5A90DA2E42F8AE43BC4A093BF06788481AA50489@SHSMSX104.ccr.corp.intel.com>
 <20171026141943.fsmd4goiec32qjkf@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171026141943.fsmd4goiec32qjkf@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, "Du, Fan" <fan.du@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hch@lst.de" <hch@lst.de>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 10/26/2017 07:19 AM, Michal Hocko wrote:
>> Current vm_normal_page implementation doesn't pick up page with DEVMAP pfn.
>> The second patch fix this and export DAX mappings into counters introduced in the
>> first patch.
>>
>> IMO, the user care more about how much persistent memory they used, how about
>> a small tweak with smaps_account, and report the total mapping size into RSS/PSS,
>> which user are usually more familiar with?
> No! Rss and pss is already used by many tools to evaluate misbehaving
> tasks. If you start accounting the memory which is not bound to the
> process life time then you can break those usecases. This is the reason
> why hugetlb is not accounted to rss as well.

Yeah, folks (rightly) assume Rss is memory and eaten from MemTotal.  DAX
mappings do not use RAM.
