From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Date: Tue, 28 Jan 2020 16:40:27 -0700
Message-ID: <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2d7e7fa2-e725-8beb-90b9-6476d48bdb33-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: io-uring <io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 1/28/20 4:36 PM, Pavel Begunkov wrote:
> On 28/01/2020 22:42, Jens Axboe wrote:
>> I didn't like it becoming a bit too complicated, both in terms of
>> implementation and use. And the fact that we'd have to jump through
>> hoops to make this work for a full chain.
>>
>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>> This makes it way easier to use. Same branch:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>
>> I'd feel much better with this variant for 5.6.
>>
> 
> Checked out ("don't use static creds/mm assignments")
> 
> 1. do we miscount cred refs? We grab one in get_current_cred() for each async
> request, but if (worker->creds != work->creds) it will never be put.

Yeah I think you're right, that needs a bit of fixing up.

> 2. shouldn't worker->creds be named {old,saved,etc}_creds? It's set as
> 
>     worker->creds = override_creds(work->creds);
> 
> Where override_creds() returns previous creds. And if so, then the following
> fast check looks strange:
> 
>     worker->creds != work->creds

Don't care too much about the naming, but the logic does appear off.
I'll take a look at both of these tonight, unless you beat me to it.

-- 
Jens Axboe
