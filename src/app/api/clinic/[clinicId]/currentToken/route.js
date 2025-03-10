import { NextResponse } from 'next/server';
import { createClient } from '@/app/utils/supabase/server';

export async function GET(request, { params }) {
  try {
    const { clinicId } = await params; // Extract clinicId from the route parameters

    if (!clinicId) {
      return NextResponse.json(
        { error: 'Clinic ID is required' },
        { status: 400 }
      );
    }

    const supabase = await createClient(); // Initialize Supabase client

    // Fetch the current token and up-next token for the specified clinic
    const { data: queueStatus, error } = await supabase
      .from('clinicqueuestatus')
      .select('current_token, up_next_token')
      .eq('clinic_id', clinicId)
      .single();
      

    if (error) {
      if (error.code === 'PGRST116') {
        return NextResponse.json(
          { data: queueStatus,
            error: "Wait for clinic to start accepting tokens"
           },
          { status: 200 }
        );
      } else {
        return NextResponse.json(
          { error: 'Failed to fetch queue status' + error.message + error.details + error.code },
          { status: 500 }
        );
      } 
    }

    // Return the current token and up-next token
    return NextResponse.json(
      { data: queueStatus },
      { status: 200 }
    );
  } catch (error) {
    return NextResponse.json(
      { error: 'Internal Server Error ' + error.message},
      { status: 500 }
    );
  }
}