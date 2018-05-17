From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] proc: Don't allow empty /proc/PID/cmdline for user tasks
Date: Thu, 17 May 2018 11:23:37 -0700
Message-ID: <CA+55aFxdnFpNoufsad2cCic8iz2MYQ8h_KV+5sM+WF9KAuJk_Q@mail.gmail.com>
References: <20180517012149.GA1718769@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="000000000000d69f84056c6aefc0"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180517012149.GA1718769@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-team <kernel-team@fb.com>, Lennart Poettering <lennart@poettering.net>
List-Id: linux-api@vger.kernel.org

--000000000000d69f84056c6aefc0
Content-Type: text/plain; charset="UTF-8"

On Wed, May 16, 2018 at 6:21 PM Tejun Heo <tj@kernel.org> wrote:

> This patch fixes the issue by making proc_pid_cmdline_read() never
> return empty string for user tasks.

Ugh.

That function really is too damn ugly, and this just makes it worse.

Can we please split things up a bit before uglifying the code further?

IOW, the first step should be something like the attached patch, which
splits up all the tsk/mm error cases.

Then your patch could just be a trivial

     if (!*pos && !ret)
         ret = get_comm_cmdline(tsk, buf, count, pos);

in that new (and much simpler) proc_pid_cmdline_read() just before the
put_task_struct.

Hmm?

NOTE! This patch is *entirely* untested, but it builds and the conversion
was pretty much entirely mechanical.

And yes, the "get_mm_cmdline()" function is still too damn ugly, and should
still be cleaned up more, but it's at least _slightly_ simpler than it used
to be, and the new logic wouldn't go into that horrible thing.

                Linus

--000000000000d69f84056c6aefc0
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_jhav5m4o0>
X-Attachment-Id: f_jhav5m4o0

IGZzL3Byb2MvYmFzZS5jIHwgNjQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKyst
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDM5IGluc2VydGlvbnMoKyks
IDI1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3Byb2MvYmFzZS5jIGIvZnMvcHJvYy9i
YXNlLmMKaW5kZXggMWE3NmQ3NTFjZjNjLi5jNGQ5NjNhMTIxNjIgMTAwNjQ0Ci0tLSBhL2ZzL3By
b2MvYmFzZS5jCisrKyBiL2ZzL3Byb2MvYmFzZS5jCkBAIC0yMDUsMTEgKzIwNSw5IEBAIHN0YXRp
YyBpbnQgcHJvY19yb290X2xpbmsoc3RydWN0IGRlbnRyeSAqZGVudHJ5LCBzdHJ1Y3QgcGF0aCAq
cGF0aCkKIAlyZXR1cm4gcmVzdWx0OwogfQogCi1zdGF0aWMgc3NpemVfdCBwcm9jX3BpZF9jbWRs
aW5lX3JlYWQoc3RydWN0IGZpbGUgKmZpbGUsIGNoYXIgX191c2VyICpidWYsCi0JCQkJICAgICBz
aXplX3QgX2NvdW50LCBsb2ZmX3QgKnBvcykKK3N0YXRpYyBzc2l6ZV90IGdldF9tbV9jbWRsaW5l
KHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCBjaGFyIF9fdXNlciAqYnVmLAorCQkJICAgICAgc2l6ZV90
IF9jb3VudCwgbG9mZl90ICpwb3MpCiB7Ci0Jc3RydWN0IHRhc2tfc3RydWN0ICp0c2s7Ci0Jc3Ry
dWN0IG1tX3N0cnVjdCAqbW07CiAJY2hhciAqcGFnZTsKIAl1bnNpZ25lZCBsb25nIGNvdW50ID0g
X2NvdW50OwogCXVuc2lnbmVkIGxvbmcgYXJnX3N0YXJ0LCBhcmdfZW5kLCBlbnZfc3RhcnQsIGVu
dl9lbmQ7CkBAIC0yMTgsMjYgKzIxNiwxMyBAQCBzdGF0aWMgc3NpemVfdCBwcm9jX3BpZF9jbWRs
aW5lX3JlYWQoc3RydWN0IGZpbGUgKmZpbGUsIGNoYXIgX191c2VyICpidWYsCiAJY2hhciBjOwog
CXNzaXplX3QgcnY7CiAKLQlCVUdfT04oKnBvcyA8IDApOwotCi0JdHNrID0gZ2V0X3Byb2NfdGFz
ayhmaWxlX2lub2RlKGZpbGUpKTsKLQlpZiAoIXRzaykKLQkJcmV0dXJuIC1FU1JDSDsKLQltbSA9
IGdldF90YXNrX21tKHRzayk7Ci0JcHV0X3Rhc2tfc3RydWN0KHRzayk7Ci0JaWYgKCFtbSkKLQkJ
cmV0dXJuIDA7CiAJLyogQ2hlY2sgaWYgcHJvY2VzcyBzcGF3bmVkIGZhciBlbm91Z2ggdG8gaGF2
ZSBjbWRsaW5lLiAqLwotCWlmICghbW0tPmVudl9lbmQpIHsKLQkJcnYgPSAwOwotCQlnb3RvIG91
dF9tbXB1dDsKLQl9CisJaWYgKCFtbS0+ZW52X2VuZCkKKwkJcmV0dXJuIDA7CiAKIAlwYWdlID0g
KGNoYXIgKilfX2dldF9mcmVlX3BhZ2UoR0ZQX0tFUk5FTCk7Ci0JaWYgKCFwYWdlKSB7Ci0JCXJ2
ID0gLUVOT01FTTsKLQkJZ290byBvdXRfbW1wdXQ7Ci0JfQorCWlmICghcGFnZSkKKwkJcmV0dXJu
IC1FTk9NRU07CiAKIAlkb3duX3JlYWQoJm1tLT5tbWFwX3NlbSk7CiAJYXJnX3N0YXJ0ID0gbW0t
PmFyZ19zdGFydDsKQEAgLTM2NSwxMyArMzUwLDQyIEBAIHN0YXRpYyBzc2l6ZV90IHByb2NfcGlk
X2NtZGxpbmVfcmVhZChzdHJ1Y3QgZmlsZSAqZmlsZSwgY2hhciBfX3VzZXIgKmJ1ZiwKIAogb3V0
X2ZyZWVfcGFnZToKIAlmcmVlX3BhZ2UoKHVuc2lnbmVkIGxvbmcpcGFnZSk7Ci1vdXRfbW1wdXQ6
Ci0JbW1wdXQobW0pOwotCWlmIChydiA+IDApCi0JCSpwb3MgKz0gcnY7CiAJcmV0dXJuIHJ2Owog
fQogCitzdGF0aWMgc3NpemVfdCBnZXRfdGFza19jbWRsaW5lKHN0cnVjdCB0YXNrX3N0cnVjdCAq
dHNrLCBjaGFyIF9fdXNlciAqYnVmLAorCQkJCXNpemVfdCBjb3VudCwgbG9mZl90ICpwb3MpCit7
CisJc3RydWN0IG1tX3N0cnVjdCAqbW07CisJc3NpemVfdCByZXQ7CisKKwltbSA9IGdldF90YXNr
X21tKHRzayk7CisJaWYgKCFtbSkKKwkJcmV0dXJuIDA7CisKKwlyZXQgPSBnZXRfbW1fY21kbGlu
ZShtbSwgYnVmLCBjb3VudCwgcG9zKTsKKwltbXB1dChtbSk7CisJcmV0dXJuIHJldDsKK30KKwor
c3RhdGljIHNzaXplX3QgcHJvY19waWRfY21kbGluZV9yZWFkKHN0cnVjdCBmaWxlICpmaWxlLCBj
aGFyIF9fdXNlciAqYnVmLAorCQkJCSAgICAgc2l6ZV90IGNvdW50LCBsb2ZmX3QgKnBvcykKK3sK
KwlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzazsKKwlzc2l6ZV90IHJldDsKKworCUJVR19PTigqcG9z
IDwgMCk7CisKKwl0c2sgPSBnZXRfcHJvY190YXNrKGZpbGVfaW5vZGUoZmlsZSkpOworCWlmICgh
dHNrKQorCQlyZXR1cm4gLUVTUkNIOworCXJldCA9IGdldF90YXNrX2NtZGxpbmUodHNrLCBidWYs
IGNvdW50LCBwb3MpOworCXB1dF90YXNrX3N0cnVjdCh0c2spOworCWlmIChyZXQgPiAwKQorCQkq
cG9zICs9IHJldDsKKwlyZXR1cm4gcmV0OworfQorCiBzdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVf
b3BlcmF0aW9ucyBwcm9jX3BpZF9jbWRsaW5lX29wcyA9IHsKIAkucmVhZAk9IHByb2NfcGlkX2Nt
ZGxpbmVfcmVhZCwKIAkubGxzZWVrCT0gZ2VuZXJpY19maWxlX2xsc2VlaywK
--000000000000d69f84056c6aefc0--
