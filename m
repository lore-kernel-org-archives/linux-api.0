From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Wed, 29 Jan 2020 13:48:54 -0700
Message-ID: <ca3b1ff4-baa9-f061-feaf-29b0b47fb6bb@kernel.dk>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
 <c9e58b5c-f66e-8406-16d5-fd6df1a27e77@kernel.dk>
 <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294@gmail.com>
 <2019e952-df2a-6b57-3571-73c525c5ba1a@kernel.dk>
 <0df4904f-780b-5d5f-8700-41df47a1b470@kernel.dk>
 <5406612e-299d-9d6e-96fc-c962eb93887f@gmail.com>
 <821243e7-b470-ad7a-c1a5-535bee58e76d@samba.org>
 <9a419bc5-4445-318d-87aa-1474b49266dd@gmail.com>
 <40d52623-5f9c-d804-cdeb-b7da6b13cb4f@samba.org>
 <3e1289de-8d8e-49cf-cc9f-fb7bc67f35d5@gmail.com>
 <9aef3b3b-7e71-f7f1-b366-2517b4d52719@kernel.dk>
 <b3382961-8288-ec09-9019-5248f87dd86c@kernel.dk>
 <2d20bbcf-c04a-a02d-2850-cc7cc5a439f7@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2d20bbcf-c04a-a02d-2850-cc7cc5a439f7-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 1/29/20 1:09 PM, Stefan Metzmacher wrote:
> Am 29.01.20 um 18:42 schrieb Jens Axboe:
>> On 1/29/20 10:34 AM, Jens Axboe wrote:
>>> On 1/29/20 7:23 AM, Pavel Begunkov wrote:
>>>>>>> The override_creds(personality_creds) has changed current->cred
>>>>>>> and get_current_cred() will just pick it up as in the default case.
>>>>>>>
>>>>>>> This would make the patch much simpler and allows put_cred() to be
>>>>>>> in io_put_work() instead of __io_req_aux_free() as explained above.
>>>>>>>
>>>>>>
>>>>>> It's one extra get_current_cred(). I'd prefer to find another way to
>>>>>> clean this up.
>>>>>
>>>>> As far as I can see it avoids a get_cred() in the IOSQE_PERSONALITY case
>>>>> and the if (!req->work.creds) for both cases.
>>>>
>>>> Great, that you turned attention to that! override_creds() is already
>>>> grabbing a ref, so it shouldn't call get_cred() there.
>>>> So, that's a bug.
>>>
>>> It's not though - one is dropped in that function, the other when the
>>> request is freed. So we do need two references to it. With the proposed
>>> change to keep the override_creds() variable local for that spot we
>>> don't, and the get_cred() can then go.
>>>
>>>> It could be I'm wrong with the statement above, need to recheck all this
>>>> code to be sure.
>>>
>>> I think you are :-)
>>>
>>>> BTW, io_req_defer_prep() may be called twice for a req, so you will
>>>> reassign it without putting a ref. It's safer to leave NULL checks. At
>>>> least, until I've done reworking and fixing preparation paths.
>>>
>>> Agree, the NULL checks are safer and we should keep them.
>>>
>>> Going through the rest of this thread, I'm making the following changes:
>>>
>>> - ID must be > 0. I like that change, as we don't need an sqe flag to
>>>   select personality then, and it also makes it obvious that id == 0 is
>>>   just using current creds.
>>>
>>> - Fixed the missing put_cred() in the teardown
>>>
>>> - Use a local variable in io_submit_sqe() instead of assigning the
>>>   creds to req->work.creds there
>>>
>>> - Use cyclic idr allocation
>>>
>>> I'm going to fold in as appropriate. If there are fixes needed on top of
>>> that, let's do them separately.
>>
>> In particular, would love a patch that only assigns req->work.creds if
>> we do go async, so we can leave the put_cred() in io_put_work()
>> instead of needing it in __io_req_aux_free().
> 
> I made some improvements here:
> 
> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-5.6/io_uring-vfs
> 
> Feel free to squash
> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=ce8812c9b935467bb08ed4d528dd92b9f67e221c
> into
> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=22021e95e73d4658a6c834a3276886e127ab8425
> and add my review to it.

Looks good to me, folded. Thanks!

> If you're confident that it's safe you can
> call io_req_work_drop_env() also in io_put_work(),

Let's look into that later, want to flush this out sooner rather than
later...


-- 
Jens Axboe
