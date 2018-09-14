From: Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH] Add /proc/<pid>/numa_vamaps for numa node information
Date: Fri, 14 Sep 2018 03:33:28 +0200
Message-ID: <CAG48ez1YhHKTDHZoH2tEFaLk4LcCSw5G60=+KpGRaMQxvw1qLw@mail.gmail.com>
References: <1525240686-13335-1-git-send-email-prakash.sangappa@oracle.com>
 <20180502143323.1c723ccb509c3497050a2e0a@linux-foundation.org>
 <2ce01d91-5fba-b1b7-2956-c8cc1853536d@intel.com> <33f96879-351f-674a-ca23-43f233f4eb1d@linux.vnet.ibm.com>
 <82d2b35c-272a-ad02-692f-2c109aacdfb6@oracle.com> <8569dabb-4930-aa20-6249-72457e2df51e@intel.com>
 <51145ccb-fc0d-0281-9757-fb8a5112ec24@oracle.com> <c72fea44-59f3-b106-8311-b5eae2d254e7@intel.com>
 <addeaadc-5ab2-f0c9-2194-dd100ae90f3a@oracle.com> <aaca3180-7510-c008-3e12-8bbe92344ef4@intel.com>
 <94ee0b6c-4663-0705-d4a8-c50342f6b483@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94ee0b6c-4663-0705-d4a8-c50342f6b483@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, kernel list <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, n-horiguchi@ah.jp.nec.com, drepper@gmail.com, rientjes@google.com, nao.horiguchi@gmail.com, steven.sistare@oracle.com
List-Id: linux-api@vger.kernel.org

On Wed, Sep 12, 2018 at 10:43 PM prakash.sangappa
<prakash.sangappa@oracle.com> wrote:
> On 05/09/2018 04:31 PM, Dave Hansen wrote:
> > On 05/07/2018 06:16 PM, prakash.sangappa wrote:
> >> It will be /proc/<pid>/numa_vamaps. Yes, the behavior will be
> >> different with respect to seeking. Output will still be text and
> >> the format will be same.
> >>
> >> I want to get feedback on this approach.
> > I think it would be really great if you can write down a list of the
> > things you actually want to accomplish.  Dare I say: you need a
> > requirements list.
> >
> > The numa_vamaps approach continues down the path of an ever-growing list
> > of highly-specialized /proc/<pid> files.  I don't think that is
> > sustainable, even if it has been our trajectory for many years.
> >
> > Pagemap wasn't exactly a shining example of us getting new ABIs right,
> > but it sounds like something along those is what we need.
>
> Just sent out a V2 patch.  This patch simplifies the file content. It
> only provides VA range to numa node id information.
>
> The requirement is basically observability for performance analysis.
>
> - Need to be able to determine VA range to numa node id information.
>    Which also gives an idea of which range has memory allocated.
>
> - The proc file /proc/<pid>/numa_vamaps is in text so it is easy to
>    directly view.
>
> The V2 patch supports seeking to a particular process VA from where
> the application could read the VA to  numa node id information.
>
> Also added the 'PTRACE_MODE_READ_REALCREDS' check when opening the
> file /proc file as was indicated by Michal Hacko

procfs files should use PTRACE_MODE_*_FSCREDS, not PTRACE_MODE_*_REALCREDS.
