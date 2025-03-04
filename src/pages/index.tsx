import { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import { createClient } from '../utils/supabase/component'; // Import the Supabase client setup

//TODO: A page function that detects if the user is authenticated or not.
export default function Page() {
    const [isAuthenticated, setIsAuthenticated] = useState(false);
    const router = useRouter();
    const supabase = createClient();

    useEffect(() => {
        async function checkAuth() {
            const { data: { session } } = await supabase.auth.getSession();
            if (session) {
                setIsAuthenticated(true);
            }
        }
        checkAuth();
    }, [supabase]);

    return (
        <main className="bg-gray-600">
            {!isAuthenticated ? (
                <button
                    className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                    onClick={() => router.push('/login')}
                >
                    Log in
                </button>
            ) : (
                <div>
                   
                </div>
            )}
        </main>
    );
}