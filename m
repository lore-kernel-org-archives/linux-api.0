From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Date: Tue, 23 Dec 2014 15:52:27 +0100
Message-ID: <4537021.IXSvIIgcH4@tachyon.chronox.de>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de> <101382546.xjTjAHLGAb@tachyon.chronox.de> <20141223115626.GA31450@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141223115626.GA31450-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Dienstag, 23. Dezember 2014, 22:56:26 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Dec 23, 2014 at 09:14:43AM +0100, Stephan Mueller wrote:
> > - the check aead_readable() immediately before this check implements the
> > blocking if we do not have sufficient data *and* more data is to be
> > expected
> Good point.
> 
> In fact AEAD is rather awkward because you need to do everything
> in one go.  Perhaps we could adapt our kernel interface to allow
> partial AEAD operations?


I am not sure what you are referring to. The invocation does not need to be in 
one go. You can have arbitrary number of sendmsg calls. But all input data 
needs to be supplied before you call recvmsg.

Please see my test code that implements the following call sequence using the 
libkcapi wrapper API calls where I dissect the data to be sent to the kernel 
for testing purposes:

if (cavs_test->enc) {
                /* send assoc with init call */
                ret = kcapi_aead_stream_init_enc(&handle, &iov, 1);
                if (0 > ret) {
                        printf("Initialization of cipher buffer failed\n");
                        goto out;
                }
                /* send plaintext with last call */
                iov.iov_base = cavs_test->pt;
                iov.iov_len = cavs_test->ptlen;
                ret = kcapi_aead_stream_update_last(&handle, &iov, 1);
                if (0 > ret) {
                        printf("Sending last update buffer failed\n");
                        goto out;
                }
                ret = kcapi_aead_stream_op(&handle, &outiov, 1);
        } else {
                /* send assoc with init call */
                ret = kcapi_aead_stream_init_dec(&handle, &iov, 1);
                if (0 > ret) {
                        printf("Initialization of cipher buffer failed\n");
                        goto out;
                }
                /* send plaintext with intermediary call */
                iov.iov_base = cavs_test->ct;
                iov.iov_len = cavs_test->ctlen;
                ret = kcapi_aead_stream_update(&handle, &iov, 1);
                if (0 > ret) {
                        printf("Sending update buffer failed\n");
                        goto out;
                }
                /* send tag with last send call */
                iov.iov_base = cavs_test->tag;
                iov.iov_len = cavs_test->taglen;
                ret = kcapi_aead_stream_update_last(&handle, &iov, 1);
                if (0 > ret) {
                        printf("Sending last update buffer failed\n");
                        goto out;
                }
                ret = kcapi_aead_stream_op(&handle, &outiov, 1);
        }

Every call to kcapi_aead_stream_init_dec / kcapi_aead_stream_update / 
kcapi_aead_stream_update_last invokes one sendmsg syscall.

In essence, kcapi_aead_stream_update can be invoked with every byte you want 
to add to the message stream. This "stream" API of libkcapi is logially 
equivalent to the init/update/final of message digests.
> 
> I want to be very careful before we pin down our user-space
> interface since that's something that we cannot easily change
> while the kernel interface can be modified at any time.

I am fully with you and try to patiently present solutions.
> 
> Thanks,


-- 
Ciao
Stephan
