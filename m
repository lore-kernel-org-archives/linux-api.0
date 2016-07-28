From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
 between namespaces
Date: Thu, 28 Jul 2016 21:00:32 +0200
Message-ID: <40e35f1a-10e6-b7a5-936e-a09f008be0d0@gmail.com>
References: <1515f5f2-5a49-fcab-61f4-8b627d3ba3e2@gmail.com>
 <CANaxB-w8H8Wo8FmtmBBZTpJX-ZDGRQx0rbm9E5c9WbduQ_Ukmw@mail.gmail.com>
 <e2811bf1-4b86-e115-bcdb-301d6f2546eb@gmail.com>
 <87lh0pg8jx.fsf@x220.int.ebiederm.org>
 <44ca0e41-dc92-45b1-2a6c-c41a048a072d@gmail.com>
 <87r3ahepb4.fsf@x220.int.ebiederm.org>
 <20160726025455.GC26206@outlook.office365.com>
 <3390535b-0660-757f-aeba-c03d936b3485@gmail.com>
 <20160726182524.GA328@outlook.office365.com>
 <CAKgNAkjmOu+vfiMDyeYQkkf7wQBH9PVmJ4nH2CTg43GrN-k7eA@mail.gmail.com>
 <20160726203955.GA9415@outlook.office365.com>
 <ca0787a3-b270-e962-46d1-7e63c9335a55@gmail.com>
 <87popxkjjp.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87popxkjjp.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, Andrew Vagin <avagin@virtuozzo.com>, Andrey Vagin <avagin@openvz.org>, "Serge E. Hallyn" <serge@hallyn.com>, "criu@openvz.org" <criu@openvz.org>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On 07/28/2016 02:56 PM, Eric W. Biederman wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>
>> On 07/26/2016 10:39 PM, Andrew Vagin wrote:
>>> On Tue, Jul 26, 2016 at 09:17:31PM +0200, Michael Kerrisk (man-pages) wrote:
>
>>> If we want to compare two file descriptors of the current process,
>>> it is one of cases for which kcmp can be used. We can call kcmp to
>>> compare two namespaces which are opened in other processes.
>>
>> Is there really a use case there? I assume we're talking about the
>> scenario where a process in one namespace opens a /proc/PID/ns/*
>> file descriptor and passes that FD to another process via a UNIX
>> domain socket. Is that correct?
>>
>> So, supposing that we want to build a map of the relationships
>> between namespaces using the proposed kcmp() API, and there are
>> say N namespaces? Does this mena we make (N * (N-1) / 2) calls
>> to kcmp()?
>
> Potentially.  The numbers are small enough O(N^2) isn't fatal.

Define "small", please.

O(N^2) makes me nervous about what other use cases lurk out
there that may get bitten by this.

> Where kcmp shines is that it allows migration to happen.  Inode numbers
> to change (which they very much will today), and still have things work.


> We can keep it O(Nlog(N)) by taking advantage of not just the equality
> but the ordering relationship.  Although Ugh.

Yes, that sounds pretty ugly...

>One disadvantage of
> kcmp currently is that the way the ordering relationship is defined
> the order is not preserved over migration :(

So, does kcmp() fully solve the proble(s) at hand? It sounds like
not, if I understand your last point correctly.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
