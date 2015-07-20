From: David Binderman <dcb314-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Subject: [linux-4.2-rc3/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c:194:
 bad if condition ?
Date: Mon, 20 Jul 2015 09:26:57 +0000
Message-ID: <DUB128-W55FA5DB7B71A53D5E73E289C850@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello there,

[linux-4.2-rc3/tools/testing/selftests/futex/functional/futex_requeue_p=
i_signal_restart.c:194]: (style) Expression is always false because 'el=
se if' condition matches previous condition at line 191.

Source code is

=A0=A0=A0=A0=A0=A0=A0 if (res> 0) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 atomic_set(&requeued, 1);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
=A0=A0=A0=A0=A0=A0=A0 } else if (res> 0) {

Regards

David Binderman

 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
