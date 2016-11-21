From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH RFC 1/6] selftests: remove duplicated all and clean target
Date: Mon, 21 Nov 2016 19:53:54 +1100
Message-ID: <87shqlw6vx.fsf@concordia.ellerman.id.au>
References: <1477047694-24122-1-git-send-email-bamvor.zhangjian@huawei.com> <1477047694-24122-2-git-send-email-bamvor.zhangjian@huawei.com> <87mvgxgjuu.fsf@concordia.ellerman.id.au> <1ffc34d0-0a4c-efd3-ed3d-6073b2ea32ac@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1ffc34d0-0a4c-efd3-ed3d-6073b2ea32ac-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhangjian (Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Zhangjian (Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> writes:
> On 2016/11/18 18:31, Michael Ellerman wrote:
>  >bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org writes:
>  >> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>  >> Currently, kselftest use TEST_PROGS, TEST_PROGS_EXTENDED, TEST_FILES to
>  >> indicate the default test program, extended test program and test files.
>  >> These lead to duplicated all and clean targets.
>  >>
>  >> In order to remove them, introduce TEST_GEN_PROGS,
>  >> TEST_GEN_PROGS_EXTENDED, TEST_GEN_FILES to indicate the compiled
>  >> objected.
>  >
>  >It's nice to be able to drop the clean rules, but renaming all those
>  >variables causes a lot of churn.
>  >
>  >I think it would be better if we add a new variable, maybe NO_CLEAN,
>  >which can be used to specify anything in TEST_PROGS/EXTENDED which
>  >should *not* be cleaned.
>  >
>  >And then the default clean rule will just do:
>  >
>  >clean:
>  >    $(RM) -fr $(filter-out $(NO_CLEAN),$(TEST_PROGS))

> Maybe I lost somewhere. I add these variable for all and
> clean target. They will be used to output the objects to OUTPUT
> directory.

No you're right, that won't work as I described it.

I reviewed this patch first and didn't look at how it was required for
patch 6 to work (and the change log doesn't mention that you need it for
patch 6 :)

> Could you please explain in details how should I do it for
> "all" target if I do not introduce TEST_GEN_PROGS,
> TEST_GEN_PROGS_EXTENDED and TEST_GEN_FILES?

I'll have to think about it a bit more.

cheers
